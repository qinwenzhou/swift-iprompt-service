//
//  AccountServiceSpec.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/29.
//

import Foundation

public struct AccountServiceSpec: ServiceSpecType {
    public var serviceIdentifier = String(describing: AccountService.self)
    
    public func makeService() -> AccountService {
        return AccountService()
    }
}
