//
//  PromptModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct PromptModel: DBModel {
    static var tableName: String {
        return "prompt"
    }
    
    var identifier: UInt64? = nil
    var userId: Int
    var id: Int
    var name: String
    var content: String
    var description: String?
    var type: Int
    var tags: [Int]?
    var attachments: [AttachCell]?
    var isLocked: Bool
    var createAt: Date
    var updateAt: Date
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = PromptModel
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(identifier, isPrimary: true, isAutoIncrement: true)
        }
        
        case identifier
        case userId = "user_id"
        case id
        case name
        case content
        case description
        case type
        case tags
        case attachments
        case isLocked = "is_locked"
        case createAt = "create_at"
        case updateAt = "update_at"
    }
}

extension PromptModel {
    static func getAllObjects(for userId: Int) throws -> [Self] {
        return try database.getObjects(
            fromTable: Self.tableName,
            where: Self.Properties.userId == userId
        )
    }
}
