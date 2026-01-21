//
//  API+Tag.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation
import Alamofire

extension API {
    public static func createTag(
        with tagCreate: TagCreate
    ) async throws -> TagRead {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.tagCreate.rawValue)
        
        let request = AS.request(
            url,
            method: .post,
            parameters: tagCreate,
            encoder: JSONParameterEncoder.snakeCase
        )
        let response = await request.serializingDecodable(
            TagRead.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let tagRead):
            return tagRead
        case .failure(let error):
            throw error
        }
    }
    
    public static func readTagList() async throws -> [TagRead] {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.tagList.rawValue)
        
        let request = AS.request(
            url,
            method: .get,
        )
        let response = await request.serializingDecodable(
            [TagRead].self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let list):
            return list
        case .failure(let error):
            throw error
        }
    }
    
    public static func readTagInfo(with tagId: Int) async throws -> TagRead {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.tagInfo.rawValue)
        
        let request = AS.request(
            url,
            method: .get,
            parameters: ["tag_id": tagId],
            encoder: JSONParameterEncoder.default
        )
        let response = await request.serializingDecodable(
            TagRead.self,
            decoder: JSONDecoder.snakeCase
        ).response
        
        switch response.result {
        case .success(let tagRead):
            return tagRead
        case .failure(let error):
            throw error
        }
    }
    
    public static func deleteTag(with tagId: Int) async throws {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.tagDelete.rawValue)
        
        let request = AS.request(
            url,
            method: .delete,
            parameters: ["tag_id": tagId],
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
    
    public static func deleteTags(with tagIds: [Int]) async throws {
        let url = try Networking.getBaseURL()
            .appending(path: "/api/v1")
            .appending(path: Self.tagDeleteList.rawValue)
        
        let request = AS.request(
            url,
            method: .delete,
            parameters: ["tag_ids": tagIds],
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
