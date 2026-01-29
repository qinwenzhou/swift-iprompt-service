//
//  TagService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation
import Combine
@preconcurrency import WCDBSwift

open class TagService: ServiceType {
    public var tagListSubject = PassthroughSubject<[TagRead], Never>()
    
    open func start() {
        
    }
    
    open func create(tag: TagCreate) async throws -> TagRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        guard userId > 0 else {
            let lastId = try await TagTable.getLastLocalTagId()
            let tagId = (lastId + 1) * (-1) // Use negative numbers to indicate local id.
            let tagModel = tag.asLocalTagModel(with: tagId)
            try await TagTable.insertOrReplace(tag: tagModel)
            return tagModel.asTagRead
        }
        let tagRead = try await API.create(tag: tag)
        let tagModel = tagRead.asTagModel(for: userId)
        try await TagTable.insertOrReplace(tag: tagModel)
        return tagRead
    }
    
    open func readCachedTagList() async throws -> [TagRead] {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        return try await TagTable.getAllTags(for: userId).map {
            $0.asTagRead
        }
    }
    
    open func readTagList() async throws -> [TagRead] {
        let user = try Networking.getCurrentUser()
        let tagList = try await API.readTagList()
        try await TagTable.insertOrReplace(tags: tagList.map {
            $0.asTagModel(for: user.account.id)
        })
        return tagList
    }
    
    open func readTagInfo(with tagId: Int64) async throws -> TagRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        guard userId > 0 else {
            let tagModel = try await TagTable.getTag(with: tagId)
            return tagModel.asTagRead
        }
        let tagRead = try await API.readTagInfo(with: tagId)
        try await TagTable.insertOrReplace(
            tag: tagRead.asTagModel(for: userId)
        )
        return tagRead
    }
    
    open func deleteTag(with tagId: Int64) async throws {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            try await API.deleteTag(with: tagId)
        }
        try await TagTable.deleteTag(with: tagId)
    }
    
    open func deleteTags(with tagIds: [Int64]) async throws {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            try await API.deleteTags(with: tagIds)
        }
        for tagId in tagIds {
            try await TagTable.deleteTag(with: tagId)
        }
    }
    
    open func stop() {
        
    }
}

extension TagCreate {
    func asLocalTagModel(with tagId: Int64) -> TagModel {
        TagModel(
            userId: 0,
            tagId: tagId,
            name: self.name,
            color: self.color,
            priority: self.priority,
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
            priority: self.priority,
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
            priority: self.priority,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}
