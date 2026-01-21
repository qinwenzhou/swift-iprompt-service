//
//  Attachment.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/19.
//

import Foundation

public struct Attachment: Codable, Sendable {
    public var name: String
    public var url: String
    public var type: Int
}
