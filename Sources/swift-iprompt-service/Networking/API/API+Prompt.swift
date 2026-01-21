//
//  API+Prompt.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
import Alamofire

extension API {
    public static func createPrompt(
        with promptCreate: PromptCreate
    ) async throws -> PromptRead {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.promptCreate.rawValue)
        
        let request = AS.request(
            url,
            method: .post,
            parameters: promptCreate,
            encoder: JSONParameterEncoder.snakeCase
        )
        let response = await request.serializingDecodable(
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
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.promptList.rawValue)
        
        let request = AS.request(
            url,
            method: .get,
        )
        let response = await request.serializingDecodable(
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
    
    public static func readPromptInfo(with promptId: Int) async throws -> PromptRead {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.promptInfo.rawValue)
        
        let request = AS.request(
            url,
            method: .get,
            parameters: ["prompt_id": promptId],
            encoder: JSONParameterEncoder.default
        )
        let response = await request.serializingDecodable(
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
    
    public static func deletePrompt(with promptId: Int) async throws {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.promptDelete.rawValue)
        
        let request = AS.request(
            url,
            method: .delete,
            parameters: ["prompt_id": promptId],
            encoder: JSONParameterEncoder.default
        )
        let response = await request.serializingDecodable(
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
