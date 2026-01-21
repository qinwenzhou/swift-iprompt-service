//
//  Tag.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/19.
//

import Foundation

public struct TagCreate: Codable, Sendable {
    public var name: String
    public var color: String
    public var priority: Int = 0
}

public struct TagRead: Identifiable, Codable, Sendable {
    public var id: Int
    public var name: String
    public var color: String
    public var priority: Int
}
