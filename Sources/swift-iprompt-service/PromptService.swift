//
//  PromptService.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/5.
//

import Foundation
@preconcurrency import WCDBSwift

open class PromptService {
    open func create(prompt: PromptCreate) async throws -> PromptRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        guard userId > 0 else {
            let lastId = try await PromptTable.getLastLocalPromptId()
            let promptId = (lastId + 1) * (-1) // Use negative numbers to indicate local id.
            let promptModel = prompt.asLocalPromptModel(with: promptId)
            try await PromptTable.insertOrReplace(prompt: promptModel)
            return promptModel.asPromptRead
        }
        let promptRead = try await API.create(prompt: prompt)
        let promptModel = promptRead.asPromptModel(for: userId)
        try await PromptTable.insertOrReplace(prompt: promptModel)
        return promptRead
    }
    
    open func readCachedPromptList() async throws -> [PromptRead] {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        return try await PromptTable.getAllPrompts(for: userId).map {
            $0.asPromptRead
        }
    }
    
    open func readPromptList() async throws -> [PromptRead] {
        let user = try Networking.getCurrentUser()
        let promptList = try await API.readPromptList()
        try await PromptTable.insertOrReplace(prompts: promptList.map {
            $0.asPromptModel(for: user.account.id)
        })
        return promptList
    }
    
    open func readPromptInfo(with promptId: Int64) async throws -> PromptRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        guard userId > 0 else {
            let promptModel = try await PromptTable.getPrompt(with: promptId)
            return promptModel.asPromptRead
        }
        let promptRead = try await API.readPromptInfo(with: promptId)
        try await PromptTable.insertOrReplace(
            prompt: promptRead.asPromptModel(for: userId)
        )
        return promptRead
    }
    
    open func deletePrompt(with promptId: Int64) async throws {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            try await API.deletePrompt(with: promptId)
        }
        try await PromptTable.deletePrompt(with: promptId)
    }
}

extension Attach {
    var asDBAttach: DBAttach {
        DBAttach(
            name: self.name,
            url: self.url,
            type: self.type
        )
    }
}

extension DBAttach {
    var asAttach: Attach {
        Attach(
            name: self.name,
            url: self.url,
            type: self.type
        )
    }
}

extension PromptCreate {
    func asLocalPromptModel(with promptId: Int64) -> PromptModel {
        PromptModel(
            userId: 0,
            promptId: promptId,
            name: self.name,
            content: self.content,
            description: self.description,
            type: self.type,
            tags: self.tags,
            attachs: self.attachs?.compactMap {
                $0.asDBAttach
            },
            isLocked: self.isLocked,
            createTime: Date.now,
            updateTime: Date.now
        )
    }
}

extension PromptRead {
    func asPromptModel(for userId: Int64) -> PromptModel {
        PromptModel(
            userId: userId,
            promptId: self.id,
            name: self.name,
            content: self.content,
            description: self.description,
            type: self.type,
            tags: self.tags,
            attachs: self.attachs?.compactMap {
                $0.asDBAttach
            },
            isLocked: self.isLocked,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}

extension PromptModel {
    var asPromptRead: PromptRead {
        PromptRead(
            id: self.promptId,
            name: self.name,
            content: self.content,
            type: self.type,
            tags: self.tags,
            attachs: self.attachs?.compactMap {
                $0.asAttach
            },
            isLocked: self.isLocked,
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}
