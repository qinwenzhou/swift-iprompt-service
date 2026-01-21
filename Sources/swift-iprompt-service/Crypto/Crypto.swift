//
//  Crypto.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

import Foundation
import CryptoSwift

private let SECRET_KEY = "nq6dVQqL6wA7gBx_npTdheKuWpJxkFfxrXkMTKf6MIs"

struct Crypto {
    func encrypt(_ content: String) throws -> String {
        guard !(content.isEmpty) else {
            throw CryptoError(message: "The content is nil.")
        }
        let aes = try AES(key: SECRET_KEY.bytes, blockMode: ECB())
        let bytes = try aes.encrypt(content.bytes)
        let encStr = bytes.toBase64()
        return encStr
    }
    
    func decrypt(_ content: String) throws -> String {
        guard !(content.isEmpty) else {
            throw CryptoError(message: "The content is nil.")
        }
        guard let data = Data(base64Encoded: content) else {
            throw CryptoError(message: "The content format is invalid.")
        }
        let aes = try AES(key: SECRET_KEY.bytes, blockMode: ECB())
        let bytes = try aes.decrypt(data.byteArray)
        guard let decStr = String(data: Data(bytes), encoding: .utf8) else {
            throw CryptoError(message: nil)
        }
        return decStr
    }
}
