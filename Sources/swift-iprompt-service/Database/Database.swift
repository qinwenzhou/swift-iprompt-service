//
//  Database.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

private let dbQueue = DispatchQueue(
    label: "iprompt.service.db.queue"
)

internal let database: Database = {
    dbQueue.sync {
        return DBManager.shared.db
    }
}()

fileprivate final class DBManager: @unchecked Sendable {
    var db: Database
    
    /// Single instance
    static let shared = DBManager()
    
    private init() {
        guard let libDir = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last else {
            fatalError("Library directory is not found!")
        }
        let dbDir = NSString(string: libDir).appendingPathComponent("database")
        let dbDirUrl = URL(fileURLWithPath: dbDir)
        if !(FileManager.default.fileExists(atPath: dbDir)) {
            do {
                try FileManager.default.createDirectory(at: dbDirUrl, withIntermediateDirectories: true)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        let dbUrl = dbDirUrl.appending(path: "iprompt.db", directoryHint: .notDirectory)
        print("db path: \(dbUrl.path())") // for debug
        db = Database(at: dbUrl)
        do {
            try self.createTables()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func createTables() throws {
        try db.create(table: LocalPromptTable.tableName, of: LocalPromptTable.self)
        try db.create(table: PromptTable.tableName, of: PromptTable.self)
        try db.create(table: LocalTabTable.tableName, of: LocalTabTable.self)
        try db.create(table: TagTable.tableName, of: TagTable.self)
        try db.create(table: UserTable.tableName, of: UserTable.self)
    }
}
