//
//  TagServiceSpec.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/29.
//

import Foundation

public struct TagServiceSpec: ServiceSpecType {
    public init() {}
    
    public var serviceIdentifier = String(describing: TagService.self)
    
    public func makeService() -> TagService {
        return TagService()
    }
}
