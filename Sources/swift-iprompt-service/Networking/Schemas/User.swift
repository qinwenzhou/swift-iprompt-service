//
//  User.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation

public struct UserCreate: Codable, Sendable {
    public var username: String
    public var password: String
    public var email: String?
    
    public init(
        username: String,
        password: String,
        email: String? = nil
    ) {
        self.username = username
        self.password = password
        self.email = email
    }
}

public struct UserLogin: Codable, Sendable {
    public var username: String
    public var password: String
    
    public init(
        username: String,
        password: String
    ) {
        self.username = username
        self.password = password
    }
}

public struct UserRead: Codable, Sendable {
    public var id: Int64
    public var username: String
    public var email: String?
    public var createTime: Date
    public var updateTime: Date
}

public struct UserAuthed: Codable, Sendable {
    public var account: UserRead
    public var token: Token
}
