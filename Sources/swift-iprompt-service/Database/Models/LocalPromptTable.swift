//
//  LocalPromptTable .swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/21.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct LocalPromptTable : DBTable {
    static var tableName: String {
        return "local_prompt"
    }
    
    var identifier: UInt64? = nil
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
        typealias Root = LocalPromptTable
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(identifier, isPrimary: true, isAutoIncrement: true)
        }
        
        case identifier
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
