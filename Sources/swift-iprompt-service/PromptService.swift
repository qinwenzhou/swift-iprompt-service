//
//  PromptService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/5.
//

import Foundation

open class PromptService {
    open func readCachedPromptList() async throws -> [PromptRead] {
        return []
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
