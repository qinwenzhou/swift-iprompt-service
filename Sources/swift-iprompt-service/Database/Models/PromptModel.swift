//
//  PromptModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct PromptModel: DBTable {
    static var tableName: String {
        return "prompt"
    }
    
    var id: Int64? = nil
    var userId: Int64
    var promptId: Int64
    var name: String
    var content: String
    var description: String?
    var type: Int
    var tags: [Int64]?
    var attachments: [DBAttach]?
    var isLocked: Bool
    var createTime: Date
    var updateTime: Date
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = PromptModel
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
            BindColumnConstraint(promptId, isUnique: true)
        }
        
        case id
        case userId = "user_id"
        case promptId = "prompt_id"
        case name
        case content
        case description
        case type
        case tags
        case attachments
        case isLocked = "is_locked"
        case createTime = "create_time"
        case updateTime = "update_time"
    }
}

extension PromptModel {
    static func getLastLocalPromptId() async throws -> Int64 {
        let record = try await Self.getObject(
            where: Self.Properties.userId == 0,
            orderBy: [Self.Properties.promptId.abs().order(.descending)]
        )
        guard let record else { return 0}
        return record.id ?? 0
    }
    
    static func getAllPrompts(for userId: Int64) async throws -> [Self] {
        try await Self.getObjects(
            where: Self.Properties.userId == userId,
            orderBy: [Self.Properties.updateTime.order(.descending)]
        )
    }
    
    static func getPrompt(with promptId: Int64) async throws -> Self {
        guard let record = try await Self.getObject(
            where: Self.Properties.promptId == promptId
        ) else {
            throw DBError(message: "Record is not found!")
        }
        return record
    }
}
