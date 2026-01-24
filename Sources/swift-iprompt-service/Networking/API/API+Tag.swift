//
//  API+Tag.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation
import Alamofire

extension API {
    public static func create(
        tag: TagCreate
    ) async throws -> TagRead {
        let response = await AS.request(
            Self.tagCreate.url(v: 1),
            method: .post,
            parameters: tag,
            encoder: JSONParameterEncoder.snakeCase
        ).serializingDecodable(
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
    
    public static func readTagList(
        
    ) async throws -> [TagRead] {
        let response = await AS.request(
            Self.tagList.url(v: 1),
            method: .get,
        ).serializingDecodable(
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
    
    public static func readTagInfo(
        with tagId: Int64
    ) async throws -> TagRead {
        let response = await AS.request(
            Self.tagInfo.url(v: 1),
            method: .get,
            parameters: ["tag_id": tagId],
            encoder: JSONParameterEncoder.default
        ).serializingDecodable(
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
    
    public static func deleteTag(
        with tagId: Int64
    ) async throws {
        let response = await AS.request(
            Self.tagDelete.url(v: 1),
            method: .delete,
            parameters: ["tag_id": tagId],
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
    
    public static func deleteTags(
        with tagIds: [Int64]
    ) async throws {
        let response = await AS.request(
            Self.tagDeleteList.url(v: 1),
            method: .delete,
            parameters: ["tag_ids": tagIds],
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
