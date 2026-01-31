//
//  TagExecutor.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/30.
//

import Foundation

public struct TagExecutor: Sendable {
    public func create(tag: TagCreate) async throws -> TagRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        let tagRead: TagRead = try await {
            if userId > 0 {
                return try await API.create(tag: tag)
            } else {
                let lastId = try await TagTable.getLastLocalTagId()
                let tagId = (lastId + 1) * (-1) // Use negative numbers to indicate local id.
                return tag.asTagRead(with: tagId)
            }
        }()
        let tagModel = tagRead.asTagModel(for: userId)
        try await TagTable.insertOrReplace(tag: tagModel)
        return tagRead
    }
    
    public func readCachedTagList() async throws -> [TagRead] {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        return try await TagTable.getAllTags(for: userId).map {
            $0.asTagRead
        }
    }
    
    public func readRemoteTagList() async throws -> [TagRead] {
        let user = try Networking.getCurrentUser()
        let tagList = try await API.readTagList()
        try await TagTable.insertOrReplace(tags: tagList.map {
            $0.asTagModel(for: user.account.id)
        })
        return tagList
    }
    
    public func readTagInfo(with tagId: Int64) async throws -> TagRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            let tagRead = try await API.readTagInfo(with: tagId)
            let tagModel = tagRead.asTagModel(for: userId)
            try await TagTable.insertOrReplace(tag: tagModel)
            return tagRead
        } else {
            let tagModel = try await TagTable.getTag(with: tagId)
            return tagModel.asTagRead
        }
    }
    
    public func deleteTag(with tagId: Int64) async throws {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            try await API.deleteTag(with: tagId)
        }
        try await TagTable.deleteTag(with: tagId)
    }
    
    public func deleteTags(with tagIds: [Int64]) async throws {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            try await API.deleteTags(with: tagIds)
        }
        for tagId in tagIds {
            try await TagTable.deleteTag(with: tagId)
        }
    }
}

extension TagCreate {
    func asTagRead(with tagId: Int64) -> TagRead {
        TagRead(
            id: tagId,
            name: self.name,
            color: self.color,
            createTime: Date.now,
            updateTime: Date.now
        )
    }
}

extension TagRead {
    func asTagModel(for userId: Int64) -> TagModel {
        TagModel(
            userId: userId,
            tagId: self.id,
            name: self.name,
            color: self.color,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}

extension TagModel {
    var asTagRead: TagRead {
        TagRead(
            id: self.tagId,
            name: self.name,
            color: self.color,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}
