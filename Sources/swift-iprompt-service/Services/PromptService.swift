//
//  PromptService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/5.
//

import Foundation
@preconcurrency import Combine
@preconcurrency import WCDBSwift

public final class PromptService: ServiceType, Sendable {
    private let executor = PromptExecutor()
    
    public let listSubject = CurrentValueSubject<[PromptRead], Never>([])
    
    public required init() {
        
    }
    
    public func start() {
        Task {
            do {
                self.listSubject.send(
                    try await self.executor.readCachedPromptList()
                )
                self.listSubject.send(
                    try await self.executor.readRemotePromptList()
                )
            } catch {
                
            }
        }
    }
    
    public func stop() {
        
    }
}

extension PromptService {
    @discardableResult
    public func create(prompt promptCreate: PromptCreate) async throws -> PromptRead {
        let promptRead = try await self.executor.create(prompt: promptCreate)
        
        var list = self.listSubject.value.filter {
            $0.id != promptRead.id
        }
        list.append(promptRead)
        
        self.listSubject.send(list)
        
        return promptRead
    }
    
    @discardableResult
    public func update(prompt promptUpdate: PromptUpdate) async throws -> PromptRead {
        let promptRead = try await self.executor.update(prompt: promptUpdate)
        
        var list = self.listSubject.value.filter {
            $0.id != promptRead.id
        }
        list.append(promptRead)
        
        self.listSubject.send(list)
        
        return promptRead
    }
    
    public func readPromptInfo(with promptId: Int64) async throws -> PromptRead {
        let prompt = try await self.executor.readPromptInfo(with: promptId)
        
        var list = self.listSubject.value.filter {
            $0.id != prompt.id
        }
        list.append(prompt)
        
        self.listSubject.send(list)
        
        return prompt
    }
    
    public func deletePrompt(with promptId: Int64) async throws {
        try await self.executor.deletePrompt(with: promptId)
        
        let list = self.listSubject.value.filter {
            $0.id != promptId
        }
        self.listSubject.send(list)
    }
}

