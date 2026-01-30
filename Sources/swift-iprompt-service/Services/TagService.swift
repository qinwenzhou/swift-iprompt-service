//
//  TagService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation
@preconcurrency import Combine
@preconcurrency import WCDBSwift

public final class TagService: ServiceType, Sendable {
    private let executor = TagExecutor()
    
    public let listSubject = CurrentValueSubject<[TagRead], Never>([])
    
    public required init() {
        
    }
    
    public func start() {
        Task {
            do {
                self.listSubject.send(
                    try await self.executor.readCachedTagList()
                )
                self.listSubject.send(
                    try await self.executor.readRemoteTagList()
                )
            } catch {
                
            }
        }
    }
    
    public func stop() {
        
    }
}

extension TagService {
    @discardableResult
    public func create(tag: TagCreate) async throws -> TagRead {
        let newTag = try await self.executor.create(tag: tag)
        
        var list = self.listSubject.value.filter {
            $0.id != newTag.id
        }
        list.append(newTag)
        
        self.listSubject.send(list)
        
        return newTag
    }
    
    public func readTagInfo(with tagId: Int64) async throws -> TagRead {
        let tag = try await self.executor.readTagInfo(with: tagId)
        
        var list = self.listSubject.value.filter {
            $0.id != tag.id
        }
        list.append(tag)
        
        self.listSubject.send(list)
        
        return tag
    }
    
    public func deleteTag(with tagId: Int64) async throws {
        try await self.executor.deleteTag(with: tagId)
        
        let list = self.listSubject.value.filter {
            $0.id != tagId
        }
        self.listSubject.send(list)
    }
    
    public func deleteTags(with tagIds: [Int64]) async throws {
        try await self.executor.deleteTags(with: tagIds)
        
        let setTagIds = Set(tagIds)
        let list = self.listSubject.value.filter {
            !(setTagIds.contains($0.id))
        }
        self.listSubject.send(list)
    }
}
