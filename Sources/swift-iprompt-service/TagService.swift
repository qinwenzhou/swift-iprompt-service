//
//  TagService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation

open class TagService {
    open func createTag(with tagCreate: TagCreate) async throws -> TagRead {
        return try await API.createTag(with: tagCreate)
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
