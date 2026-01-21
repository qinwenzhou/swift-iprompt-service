//
//  TagTable.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct TagTable: DBTable {
    static var tableName: String {
        return "tag"
    }
    
    var identifier: UInt64? = nil
    var userId: Int
    var id: Int
    var name: String
    var color: String
    var priority: Int
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TagTable
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(identifier, isPrimary: true, isAutoIncrement: true)
        }
        
        case identifier
        case userId = "user_id"
        case id
        case name
        case color
        case priority
    }
}
