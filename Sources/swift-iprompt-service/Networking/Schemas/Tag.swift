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
    
    init(
        name: String,
        color: String
    ) {
        self.name = name
        self.color = color
    }
}

public struct TagRead: Codable, Sendable {
    public var id: Int64
    public var name: String
    public var color: String
    public var createTime: Date
    public var updateTime: Date
}
