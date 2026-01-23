//
//  DBError.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/22.
//

import Foundation

public struct DBError {
    var message: String?
}

extension DBError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}

extension Error {
    public var asDBError: DBError? {
        return self as? DBError
    }
}
