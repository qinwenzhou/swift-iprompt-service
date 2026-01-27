//
//  Prompt.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/19.
//

import Foundation

public struct PromptCreate: Codable, Sendable {
    public var name: String
    public var content: String
    public var description: String?
    public var type: Int
    public var tags: [Int64]?
    public var attachs: [Attach]?
}

public struct PromptRead: Codable, Sendable {
    public var id: Int64
    public var name: String
    public var content: String
    public var description: String?
    public var type: Int
    public var tags: [Int64]?
    public var attachs: [Attach]?
    public var createTime: Date
    public var updateTime: Date
}
