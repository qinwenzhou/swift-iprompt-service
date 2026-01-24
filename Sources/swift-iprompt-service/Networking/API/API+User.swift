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
        user: UserCreate
    ) async throws -> UserAuthed {
        let response = await AS.request(
            Self.userRegister.url(v: 1),
            method: .post,
            parameters: user,
            encoder: JSONParameterEncoder.snakeCase
        ).serializingDecodable(
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
    
    public static func login(
        email user: UserLogin
    ) async throws -> UserAuthed {
        let response = await AS.request(
            Self.userLoginEmail.url(v: 1),
            method: .post,
            parameters: user,
            encoder: JSONParameterEncoder.snakeCase
        ).serializingDecodable(
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
    
    internal static func refresh(
        token: String
    ) async throws -> Token {
        let response = await AS.request(
            Self.userTokenRefresh.url(v: 1),
            method: .post,
            parameters: ["token": token],
            encoder: JSONParameterEncoder.default
        ).serializingDecodable(
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
        let response = await AS.request(
            Self.userMe.url(v: 1),
            method: .get,
        ).serializingDecodable(
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
