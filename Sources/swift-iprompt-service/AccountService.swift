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
        try await UserTable.insertOrReplace(user: user.asUserModel)
        try Networking.store(user: user)
        return user
    }
    
    open func login(with userLogin: UserLogin) async throws -> UserAuthed {
        let user = try await API.login(with: userLogin)
        try await UserTable.insertOrReplace(user: user.asUserModel)
        try Networking.store(user: user)
        return user
    }
    
    open func refreshToken() async throws {
        var user = try Networking.getCurrentUser()
        user.token = try await API.refresh(token: user.token.accessToken)
        try Networking.store(user: user)
    }
    
    open func readMe() async throws -> UserRead {
        var currentUser = try Networking.getCurrentUser()
        let userRead = try await API.readMe()
        try await UserTable.insertOrReplace(user: userRead.asUserModel)
        currentUser.account = userRead
        try Networking.store(user: currentUser)
        return userRead
    }
}

extension UserAuthed {
    var asUserModel: UserModel {
        UserModel(
            userId: self.account.id,
            username: self.account.username,
            memberLevel: 0,
            isSuperuser: false,
            createTime: self.account.createTime,
            updateTime: self.account.updateTime
        )
    }
}

extension UserRead {
    var asUserModel: UserModel {
        UserModel(
            userId: self.id,
            username: self.username,
            memberLevel: 0,
            isSuperuser: false,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}

extension UserModel {
    var asUserRead: UserRead {
        UserRead(
            id: self.userId,
            username: self.username,
            email: self.email,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}
