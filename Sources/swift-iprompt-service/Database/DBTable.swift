//
//  DBTable.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/21.
//

import Foundation
@preconcurrency import WCDBSwift

internal protocol DBTable: TableCodable, Sendable {
    static var tableName: String {get}
    
    static func getObjects(
        on propertyConvertibleList: PropertyConvertible...,
        where condition: Condition?,
        orderBy orderList: [OrderBy]?,
        limit: Limit?,
        offset: Offset?
    ) async throws -> [Self]
    
    static func getObject(
        on propertyConvertibleList: PropertyConvertible...,
        where condition: Condition?,
        orderBy orderList: [OrderBy]?
    ) async throws -> Self?
    
    static func insertOrReplace(
        objects: [Self]
    ) async throws
    
    static func delete(
        where condition: Condition?,
        orderBy orderList: [OrderBy]?,
        limit: Limit?,
        offset: Offset?
    ) async throws
}

extension DBTable {
    static func getObjects(
        on propertyConvertibleList: PropertyConvertible...,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil
    ) async throws -> [Self] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try database.run(transaction: { db in
                    do {
                        let list: [Self] = try db.getObjects(
                            on: propertyConvertibleList,
                            fromTable: Self.tableName,
                            where: condition,
                            orderBy: orderList,
                            limit: limit,
                            offset: offset
                        )
                        continuation.resume(returning: list)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                })
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    static func getObject(
        on propertyConvertibleList: PropertyConvertible...,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil
    ) async throws -> Self? {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try database.run(transaction: { db in
                    do {
                        let record: Self? = try db.getObject(
                            on: propertyConvertibleList,
                            fromTable: Self.tableName,
                            where: condition,
                            orderBy: orderList
                        )
                        continuation.resume(returning: record)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                })
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    static func insertOrReplace(objects: [Self]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try database.run(transaction: { db in
                    do {
                        try db.insertOrReplace(objects, intoTable: Self.tableName)
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
    
    static func delete(
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try database.run(transaction: { db in
                    do {
                        try db.delete(
                            fromTable: Self.tableName,
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
