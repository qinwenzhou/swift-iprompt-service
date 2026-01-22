//
//  TagService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation
@preconcurrency import WCDBSwift

open class TagService {
    open func readCachedTagList() async throws -> [TagRead] {
        let user = try? Networking.getCurrentUser()
        let userId = user?.id ?? 0
        
        return try await TagTable.getObjects(
            where: TagModel.Properties.userId == userId,
            orderBy: [TagModel.Properties.updateTime.order(.descending)]
        ).map {
            $0.asTagRead
        }
    }
    
    open func createTag(with tagCreate: TagCreate) async throws -> TagRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.id ?? 0

        guard userId > 0 else {
            let lastId = try await TagTable.getLastLocalTagId()
            let tagId = (lastId + 1) * -1 // Use negative numbers to indicate local id.
            let tagRead = tagCreate.asTagRead(with: tagId)
            let tagModel = tagRead.asTagModel(for: userId)
            try await TagTable.insert(objects: [tagModel])
            return tagRead
        }
        
        let tagRead = try await API.createTag(with: tagCreate)
        let tagModel = tagRead.asTagModel(for: userId)
        if let _ = try await TagTable.getObject(
            where: TagModel.Properties.userId == userId && TagModel.Properties.tagId == tagRead.id
        ) {
            
        } else {
            try await TagTable.insert(objects: [tagModel])
        }
        return tagRead
    }
    
    open func readTagList() async throws -> [TagRead] {
        return try await API.readTagList()
    }
    
    open func readTagInfo(with tagId: Int) async throws -> TagRead {
        return try await API.readTagInfo(with: tagId)
    }
    
    open func deleteTag(with tagId: Int) async throws {
        return try await API.deleteTag(with: tagId)
    }
    
    open func deleteTags(with tagIds: [Int]) async throws {
        return try await API.deleteTags(with: tagIds)
    }
}

extension TagCreate {
    fileprivate func asTagRead(with id: Int64) -> TagRead {
        TagRead(
            id: id,
            name: self.name,
            color: self.color,
            priority: self.priority,
            createTime: Date.now,
            updateTime: Date.now
        )
    }
}

extension TagRead {
    fileprivate func asTagModel(for userId: Int64) -> TagModel {
        TagModel(
            userId: userId,
            tagId: self.id,
            name: self.name,
            color: self.color,
            priority: self.priority,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}

extension TagModel {
    fileprivate var asTagRead: TagRead {
        TagRead(
            id: self.tagId,
            name: self.name,
            color: self.color,
            priority: self.priority,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}
