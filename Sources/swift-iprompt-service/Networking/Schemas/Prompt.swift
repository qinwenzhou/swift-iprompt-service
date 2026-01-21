//
//  Prompt.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/19.
//

public struct PromptCreate: Codable, Sendable {
    public var name: String
    public var content: String
    public var description: String?
    public var type: Int
    public var tags: [TagRead]?
    public var attachments: [Attachment]?
    public var isLocked: Bool
}

public struct PromptRead: Identifiable, Codable, Sendable {
    public var id: Int
    public var name: String
    public var content: String
    public var description: String?
    public var type: Int
    public var tags: [TagRead]?
    public var attachments: [Attachment]?
    public var isLocked: Bool
}
