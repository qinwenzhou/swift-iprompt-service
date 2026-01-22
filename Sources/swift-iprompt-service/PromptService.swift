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
        let user = try? Networking.getCurrentUser()
        let userId = user?.id ?? 0
        return try PromptModel.getObjects(
            where: PromptModel.Properties.userId == userId,
            orderBy: [PromptModel.Properties.updateTime.order(.descending)]
        ).map {
            $0.asPromptRead
        }
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

extension DBAttach {
    fileprivate var asAttach: Attach {
        Attach(
            name: self.name,
            url: self.url,
            type: self.type
        )
    }
}

extension PromptModel {
    fileprivate var asPromptRead: PromptRead {
        PromptRead(
            id: self.promptId,
            name: self.name,
            content: self.content,
            type: self.type,
            tags: self.tags,
            attachments: self.attachments?.compactMap {
                $0.asAttach
            },
            isLocked: self.isLocked,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}
