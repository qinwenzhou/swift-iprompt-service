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
}

public struct UserLogin: Codable, Sendable {
    public var email: String
    public var password: String
}

public struct UserRead: Codable, Sendable {
    public var id: Int
    public var username: String
    public var email: String?
}

public struct UserAuthed: Codable, Sendable {
    public var id: Int
    public var username: String
    public var email: String?
    public var token: Token
}
