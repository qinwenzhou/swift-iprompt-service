//
//  TagModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

struct TagModel: TableCodable {
    static var tableName: String {
        return "tag"
    }
    
    var id: Int
    var userId: Int
    var tagId: Int
    var name: String
    var color: String
    var priority: Int
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TagModel
        
        case id
        case userId = "user_id"
        case tagId = "tag_id"
        case name
        case color
        case priority
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }
    }
}
