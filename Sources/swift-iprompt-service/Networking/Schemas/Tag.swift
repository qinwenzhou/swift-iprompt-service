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

public struct TagRead: Codable, Sendable {
    public var id: Int64
    public var name: String
    public var color: String
    public var priority: Int
    public var createTime: Date
    public var updateTime: Date
}
