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
    public var attachments: [Attach]?
    public var isLocked: Bool
}

public struct PromptRead: Codable, Sendable {
    public var id: Int64
    public var name: String
    public var content: String
    public var description: String?
    public var type: Int
    public var tags: [Int64]?
    public var attachments: [Attach]?
    public var isLocked: Bool
    public var createTime: Date
    public var updateTime: Date
}
