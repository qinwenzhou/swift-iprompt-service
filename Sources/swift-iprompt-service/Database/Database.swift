//
//  Database.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal let db: Database = {
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
    
    let db = Database(at: dbUrl)
    do {
        try db.run(transaction: { hd in
            try hd.create(table: UserModel.tableName, of: UserModel.self)
            try hd.create(table: TagModel.tableName, of: TagModel.self)
            try hd.create(table: PromptModel.tableName, of: PromptModel.self)
        })
    } catch {
        fatalError(error.localizedDescription)
    }
    return db
}()
