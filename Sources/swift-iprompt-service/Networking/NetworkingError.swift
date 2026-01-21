//
//  NetworkingError.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation

public struct NetworkingError {
    var message: String?
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}

extension Error {
    public var asNetworkingError: NetworkingError? {
        return self as? NetworkingError
    }
}
