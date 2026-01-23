//
//  DBAttach.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/22.
//

import Foundation

internal struct DBAttach: Codable, Sendable {
    var name: String
    var url: String
    var type: String
}
