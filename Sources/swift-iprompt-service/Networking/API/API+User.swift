//
//  API+User.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
import Alamofire

extension API {
    public static func register(
        with userCreate: UserCreate
    ) async throws -> UserAuthed {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.userRegister.rawValue)
        
        let request = AS.request(
            url,
            method: .post,
            parameters: userCreate,
            encoder: JSONParameterEncoder.snakeCase
        )
        let response = await request.serializingDecodable(
            UserAuthed.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let userAuthed):
            return userAuthed
        case .failure(let error):
            throw error
        }
    }
    
    internal static func login(
        with userLogin: UserLogin
    ) async throws -> UserAuthed {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.userToken.rawValue)
        
        let request = AS.request(
            url,
            method: .post,
            parameters: userLogin,
            encoder: JSONParameterEncoder.snakeCase
        )
        let response = await request.serializingDecodable(
            UserAuthed.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let userAuthed):
            return userAuthed
        case .failure(let error):
            throw error
        }
    }
    
    internal static func refresh(token: String) async throws -> Token {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.userTokenRefresh.rawValue)
        
        let request = AS.request(
            url,
            method: .post,
            parameters: ["token": token],
            encoder: JSONParameterEncoder.default
        )
        let response = await request.serializingDecodable(
            Token.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let tokenModel):
            return tokenModel
        case .failure(let error):
            throw error
        }
    }
    
    internal static func readMe() async throws -> UserRead {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.userMe.rawValue)
        
        let request = AS.request(
            url,
            method: .get,
        )
        let response = await request.serializingDecodable(
            UserRead.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let userRead):
            return userRead
        case .failure(let error):
            throw error
        }
    }
}
