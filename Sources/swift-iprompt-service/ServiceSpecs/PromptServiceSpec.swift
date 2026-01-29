//
//  PromptServiceSpec.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/29.
//

import Foundation

public struct PromptServiceSpec: ServiceSpecType {
    public var serviceIdentifier = String(describing: PromptService.self)
    
    public func makeService() -> PromptService {
        return PromptService()
    }
}
