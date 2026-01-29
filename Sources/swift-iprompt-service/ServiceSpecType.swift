//
//  ServiceSpecType.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/29.
//

public protocol ServiceSpecType {
    associatedtype Service: ServiceType
    
    var serviceIdentifier: String { get }
    
    func makeService() -> Service
}
