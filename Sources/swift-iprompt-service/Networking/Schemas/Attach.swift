//
//  Attach.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/19.
//

import Foundation

public struct Attach: Codable, Sendable {
    public var name: String
    public var url: String
    public var type: String
    
    public init(
        name: String,
        url: String,
        type: String
    ) {
        self.name = name
        self.url = url
        self.type = type
    }
}
