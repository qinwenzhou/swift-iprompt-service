//
//  PromptService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/5.
//

import Foundation
@preconcurrency import WCDBSwift

open class PromptService {
    open func readCachedPromptList() async throws -> [PromptRead] {
        var promptList = try LocalPromptModel.getAllObjects().map {
            $0.asPromptRead
        }
        if let user = try? Networking.getCurrentUser() {
            let userPrompts = try PromptModel.getAllObjects(for: user.id).map {
                $0.asPromptRead
            }
            promptList = promptList + userPrompts
        }
        return promptList
    }
    
    open func createPrompt(with promptCreate: PromptCreate) async throws -> PromptRead {
        return try await API.createPrompt(with: promptCreate)
    }
    
    open func readPromptList() async throws -> [PromptRead] {
        return try await API.readPromptList()
    }
    
    open func readPromptInfo(with promptId: Int) async throws -> PromptRead {
        return try await API.readPromptInfo(with: promptId)
    }
    
    open func deletePrompt(with promptId: Int) async throws {
        return try await API.deletePrompt(with: promptId)
    }
}

extension LocalPromptModel {
    fileprivate var asPromptRead: PromptRead {
        PromptRead(
            id: 0,
            name: self.name,
            content: self.content,
            type: self.type,
            isLocked: self.isLocked,
            createAt: self.createAt,
            updateAt: self.updateAt
        )
    }
}

extension PromptModel {
    fileprivate var asPromptRead: PromptRead {
        PromptRead(
            id: 0,
            name: self.name,
            content: self.content,
            type: self.type,
            isLocked: self.isLocked,
            createAt: self.createAt,
            updateAt: self.updateAt
        )
    }
}
