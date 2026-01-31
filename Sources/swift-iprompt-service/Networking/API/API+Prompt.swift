//
//  API+Prompt.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
import Alamofire

extension API {
    public static func create(
        pompt pomptCreate: PromptCreate
    ) async throws -> PromptRead {
        let response = await AS.request(
            Self.promptCreate.url(v: 1),
            method: .post,
            parameters: pomptCreate,
            encoder: JSONParameterEncoder.snakeCase
        ).serializingDecodable(
            PromptRead.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let promptRead):
            return promptRead
        case .failure(let error):
            throw error
        }
    }
    
    public static func update(
        prompt promptUpdate: PromptUpdate
    ) async throws -> PromptRead {
        let response = await AS.request(
            Self.promptUpdate.url(v: 1),
            method: .post,
            parameters: promptUpdate,
            encoder: JSONParameterEncoder.snakeCase
        ).serializingDecodable(
            PromptRead.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let promptRead):
            return promptRead
        case .failure(let error):
            throw error
        }
    }
    
    public static func readPromptList() async throws -> [PromptRead] {
        let response = await AS.request(
            Self.promptList.url(v: 1),
            method: .get,
        ).serializingDecodable(
            [PromptRead].self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let list):
            return list
        case .failure(let error):
            throw error
        }
    }
    
    public static func readPromptInfo(
        with promptId: Int64
    ) async throws -> PromptRead {
        let response = await AS.request(
            Self.promptInfo.url(v: 1),
            method: .get,
            parameters: ["prompt_id": promptId],
            encoder: JSONParameterEncoder.default
        ).serializingDecodable(
            PromptRead.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let promptRead):
            return promptRead
        case .failure(let error):
            throw error
        }
    }
    
    public static func deletePrompt(
        with promptId: Int64
    ) async throws {
        let response = await AS.request(
            Self.promptDelete.url(v: 1),
            method: .delete,
            parameters: ["prompt_id": promptId],
            encoder: JSONParameterEncoder.default
        ).serializingDecodable(
            Empty.self
        ).response
        
        switch response.result {
        case .success:
            break
        case .failure(let error):
            throw error
        }
    }
}
