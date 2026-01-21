//
//  CryptoError.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation

struct CryptoError {
    var message: String?
}

extension CryptoError: LocalizedError {
    var errorDescription: String? {
        return self.message
    }
}

extension Error {
    var asCryptoError: CryptoError? {
        return self as? CryptoError
    }
}
