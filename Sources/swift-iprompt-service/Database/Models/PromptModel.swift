//
//  PromptModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

struct PromptModel: TableCodable {
    static var tableName: String {
        return "prompt"
    }
    
    var id: Int
    var userId: Int
    var promptId: Int
    var name: String
    var content: String
    var description: String?
    var type: Int
    var tags: String?
    var attachments: String?
    var isLocked: Bool
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = PromptModel
        
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
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }
    }
}
