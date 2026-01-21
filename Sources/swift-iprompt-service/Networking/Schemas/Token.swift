//
//  Token.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation

public struct Token: Codable, Sendable {
    public var accessToken: String
    public var tokenType: String
}
