//
//  AccountService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/5.
//

import Foundation

open class AccountService {
    open func register(with userCreate: UserCreate) async throws -> UserAuthed {
        let user = try await API.register(with: userCreate)
        try Networking.store(user: user)
        return user
    }
    
    open func login(with userLogin: UserLogin) async throws -> UserAuthed {
        let user = try await API.login(with: userLogin)
        try Networking.store(user: user)
        return user
    }
    
    open func refreshToken() async throws {
        var user = try Networking.getCurrentUser()
        user.token = try await API.refresh(token: user.token.accessToken)
        try Networking.store(user: user)
    }
    
    open func readMe() async throws -> UserRead {
        return try await API.readMe()
    }
}
