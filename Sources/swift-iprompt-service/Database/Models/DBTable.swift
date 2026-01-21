//
//  DBTable.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/21.
//

import Foundation
@preconcurrency import WCDBSwift

internal protocol DBTable: TableCodable {
    static var tableName: String {get}
}

