//
//  Networking.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
import Alamofire
import KeychainAccess

private let KEYCHAIN_SERVICE = "com.prompt.service"
private let KC_AUTHED_USER_KEY = "authed.user"

public final class Networking: @unchecked Sendable {
    /// Single instance
    internal static let shared = Networking()
    
    private init() {
        self.user = try? Networking.readStoredUser()
    }
    
    // MARK: - Public

    public enum Environment {
        case develop
        case testing
        case staging
        case production
    }
    
    /// Environment
    public static var environment: Networking.Environment {
        return Networking.shared.env
    }
    
    /// Configuration
    /// - Parameter environment: ``Networking.Environment``
    public static func configure(environment: Networking.Environment) {
        Networking.shared.env = environment
    }
    
    /// Get base URL
    public static func getBaseURL() throws -> URL {
        let host = Networking.shared.host
        guard let url = URL(string: host) else {
            throw NetworkingError(message: "The URL: \(host) is invalid.")
        }
        return url
    }
    
    /// Authed user
    public static func getCurrentUser() throws -> UserAuthed {
        guard let user = Networking.shared.user else {
            throw NetworkingError(message: "Not yet logged in.")
        }
        return user
    }
    

    // MARK: - Internal
    
    internal static func store(user: UserAuthed) throws {
        Networking.shared.user = user
        
        let data = try JSONEncoder().encode(user)
        guard let content = String(data: data, encoding: .utf8) else {
            throw NetworkingError(message: nil)
        }
        let enc = try Crypto().encrypt(content)
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        try keychain.set(enc, key: KC_AUTHED_USER_KEY)
    }
    
    internal static func readStoredUser() throws -> UserAuthed {
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        guard let enc = try keychain.get(KC_AUTHED_USER_KEY) else {
            throw NetworkingError(message: "No cached user.")
        }
        let dec = try Crypto().decrypt(enc)
        guard let data = dec.data(using: .utf8) else {
            throw NetworkingError(message: nil)
        }
        return try JSONDecoder().decode(UserAuthed.self, from: data)
    }
    
    // MARK: - Private
    
    private let userQueue = DispatchQueue(
        label: "iprompt.service.user.queue"
    )
    
    private var _user: UserAuthed?
    
    private var user: UserAuthed? {
        set {
            userQueue.sync {
                _user = newValue
            }
        }
        get {
            return userQueue.sync {
                _user
            }
        }
    }
    
    /// Environment (private)
    private var env: Networking.Environment = .develop {
        didSet {
            self.host = self.host(for: env)
        }
    }
    
    /// Host (private)
    private lazy var host: String = self.host(for: self.env)
    
    private func host(for env: Networking.Environment) -> String {
        switch self.env {
        case .develop:
            return "https://www.qinwenzhou.com"
        case .testing: 
            return "https://www.qinwenzhou.com"
        case .staging: 
            return "https://www.qinwenzhou.com"
        case .production: 
            return "https://www.qinwenzhou.com"
        }
    }
}

// MARK: -

internal let AS: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 60
    
    return Alamofire.Session(
        configuration: configuration,
        interceptor: RequestInterceptor()
    )
}()

private final class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping @Sendable (Result<URLRequest, Error>) -> Void
    ) {
        guard let url = urlRequest.url else {
            completion(.success(urlRequest))
            return
        }
        
        guard let host = try? Networking.getBaseURL().path() else {
            completion(.success(urlRequest))
            return
        }
        
        guard url.absoluteString.hasPrefix(host) else {
            completion(.success(urlRequest))
            return
        }
        
        var request = urlRequest
        
        if let user = try? Networking.getCurrentUser() {
            request.setValue(user.token.accessToken, forHTTPHeaderField: "Authorization")
        }
        
        let commonHeaders: [String: String] = [
            "User-Agent": Alamofire.HTTPHeader.defaultUserAgent.value,
        ]
        for (key, value) in commonHeaders {
            if request.value(forHTTPHeaderField: key) == nil {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        completion(.success(request))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping @Sendable (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse,
                response.statusCode == HTTPStatusCode.unauthorized.rawValue else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        Task {
            do {
                var user = try Networking.getCurrentUser()
                user.token = try await API.refresh(token: user.token.accessToken)
                try Networking.store(user: user)
                
                completion(.retryWithDelay(1))
            } catch {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
