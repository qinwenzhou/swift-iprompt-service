//
//  PromptExecutor.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/30.
//

import Foundation

public struct PromptExecutor: Sendable {
    public func create(prompt: PromptCreate) async throws -> PromptRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        let promptRead: PromptRead = try await {
            if userId > 0 {
                return try await API.create(prompt: prompt)
            } else {
                let lastId = try await PromptTable.getLastLocalPromptId()
                let promptId = (lastId + 1) * -1
                return prompt.asPromptRead(with: promptId)
            }
        }()
        let promptModel = promptRead.asPromptModel(for: userId)
        try await PromptTable.insertOrReplace(prompt: promptModel)
        return promptRead
    }
    
    public func update(prompt: PromptRead) async throws {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            try await API.update(prompt: prompt)
        }
        let promptModel = prompt.asPromptModel(for: userId)
        try await PromptTable.insertOrReplace(prompt: promptModel)
    }
    
    public func readCachedPromptList() async throws -> [PromptRead] {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        return try await PromptTable.getAllPrompts(for: userId).map {
            $0.asPromptRead
        }
    }
    
    public func readRemotePromptList() async throws -> [PromptRead] {
        let user = try Networking.getCurrentUser()
        let promptList = try await API.readPromptList()
        try await PromptTable.insertOrReplace(prompts: promptList.map {
            $0.asPromptModel(for: user.account.id)
        })
        return promptList
    }
    
    public func readPromptInfo(with promptId: Int64) async throws -> PromptRead {
        let user = try? Networking.getCurrentUser()
        let userId = user?.account.id ?? 0
        if userId > 0 {
            let promptRead = try await API.readPromptInfo(with: promptId)
            let promptModel = promptRead.asPromptModel(for: userId)
            try await PromptTable.insertOrReplace(prompt: promptModel)
            return promptRead
        } else {
            let promptModel = try await PromptTable.getPrompt(with: promptId)
            return promptModel.asPromptRead
        }
    }
    
    public func deletePrompt(with promptId: Int64) async throws {
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
    func asPromptRead(with promptId: Int64) -> PromptRead {
        PromptRead(
            id: promptId,
            name: self.name,
            content: self.content,
            remark: self.remark,
            type: self.type,
            tags: self.tags,
            attachs: self.attachs,
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
            remark: self.remark,
            type: self.type,
            tags: self.tags,
            attachs: self.attachs?.compactMap {
                $0.asDBAttach
            },
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
            remark: self.remark,
            type: self.type,
            tags: self.tags,
            attachs: self.attachs?.compactMap {
                $0.asAttach
            },
            createTime: self.createTime,
            updateTime: self.updateTime
        )
    }
}
