//
//  Database+Sync.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/23.
//

import Foundation
@preconcurrency import WCDBSwift

extension Database: DBAsyncCompatible {}

extension DBAsyncWrapper where Base: Database {
    func getObjects<Object: TableDecodable & Sendable>(
        on propertyConvertibleList: [PropertyConvertible] = Object.Properties.all,
        fromTable table: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil
    ) async throws -> [Object] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try self.base.run(transaction: { db in
                    do {
                        let objects: [Object] = try db.getObjects(
                            on: propertyConvertibleList,
                            fromTable: table,
                            where: condition,
                            orderBy: orderList,
                            limit: limit,
                            offset: offset
                        )
                        continuation.resume(returning: objects)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                })
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getObject<Object: TableDecodable & Sendable>(
        on propertyConvertibleList: [PropertyConvertible] = Object.Properties.all,
        fromTable table: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        offset: Offset? = nil
    ) async throws -> Object? {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try self.base.run(transaction: { db in
                    do {
                        let object: Object? = try db.getObject(
                            on: propertyConvertibleList.isEmpty ? Object.Properties.all : propertyConvertibleList,
                            fromTable: table,
                            where: condition,
                            orderBy: orderList,
                            offset: offset
                        )
                        continuation.resume(returning: object)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                })
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func insertOrReplace<Object: TableEncodable>(
        _ objects: [Object],
        on propertyConvertibleList: [PropertyConvertible]? = nil,
        intoTable table: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try self.base.run(transaction: { db in
                    do {
                        try db.insertOrReplace(
                            objects,
                            on: propertyConvertibleList,
                            intoTable: table
                        )
                        continuation.resume(returning: ())
                    } catch {
                        continuation.resume(throwing: error)
                    }
                })
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func delete(
        fromTable table: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try self.base.run(transaction: { db in
                    do {
                        try db.delete(
                            fromTable: table,
                            where: condition,
                            orderBy: orderList,
                            limit: limit,
                            offset: offset
                        )
                        continuation.resume(returning: ())
                    } catch {
                        continuation.resume(throwing: error)
                    }
                })
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
