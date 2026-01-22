//
//  TagModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct TagModel: DBTable {
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
            BindColumnConstraint(tagId, isUnique: true)
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
        guard let record = try await Self.getObject(
            where: Self.Properties.userId == 0,
            orderBy: [Self.Properties.tagId.abs().order(.descending)]
        ) else {
            return 0
        }
        return record.id ?? 0
    }
    
    static func getAllTags(for userId: Int64) async throws -> [Self] {
        try await Self.getObjects(
            where: Self.Properties.userId == userId,
            orderBy: [Self.Properties.updateTime.order(.descending)]
        )
    }
    
    static func getTag(with tagId: Int64) async throws -> Self {
        guard let record = try await Self.getObject(
            where: Self.Properties.tagId == tagId
        ) else {
            throw DBError(message: "Record is not found!")
        }
        return record
    }
    
    static func deleteTag(with tagId: Int64) async throws {
        try await Self.delete(where: Self.Properties.tagId == tagId)
    }
}
