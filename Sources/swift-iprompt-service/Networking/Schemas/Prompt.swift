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
    public var remark: String?
    public var type: Int = 0
    public var tags: [Int64]?
    public var attachs: [Attach]?
    
    public init(
        name: String,
        content: String,
        remark: String? = nil,
        type: Int = 0,
        tags: [Int64]? = nil,
        attachs: [Attach]? = nil
    ) {
        self.name = name
        self.content = content
        self.remark = remark
        self.type = type
        self.tags = tags
        self.attachs = attachs
    }
}

public struct PromptRead: Codable, Sendable {
    public var id: Int64
    public var name: String
    public var content: String
    public var remark: String?
    public var type: Int
    public var tags: [Int64]?
    public var attachs: [Attach]?
    public var createTime: Date
    public var updateTime: Date
}
