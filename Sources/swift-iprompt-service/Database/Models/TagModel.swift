//
//  TagModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct TagModel: DBTable, Sendable {
    static var tableName: String {
        return "tag"
    }
    
    var id: Int64? = nil
    var userId: Int64
    var tagId: Int64
    var name: String
    var color: String
    var priority: Int
    var createTime: Date
    var updateTime: Date
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TagModel
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }
        
        case id
        case userId = "user_id"
        case tagId = "tag_id"
        case name
        case color
        case priority
        case createTime = "create_time"
        case updateTime = "update_time"
    }
}

extension TagModel {
    static func getLastLocalTagId() async throws -> Int64 {
        let record = try await Self.getObject(
            where: Self.Properties.userId == 0,
            orderBy: [Self.Properties.tagId.abs().order(.descending)]
        )
        guard let record else { return 0}
        return record.id ?? 0
    }
}
