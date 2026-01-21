//
//  LocalTabTable.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/21.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct LocalTabTable: DBTable {
    static var tableName: String {
        return "local_tag"
    }
    
    var identifier: UInt64? = nil
    var name: String
    var color: String
    var priority: Int
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = LocalTabTable
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(identifier, isPrimary: true, isAutoIncrement: true)
        }
        
        case identifier
        case name
        case color
        case priority
    }
}
