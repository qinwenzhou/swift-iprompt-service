//
//  SrvError.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation

public struct SrvError {
    public var message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
}

extension SrvError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}

extension Error {
    public var asSrvError: SrvError? {
        return self as? SrvError
    }
}
