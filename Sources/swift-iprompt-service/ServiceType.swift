//
//  ServiceType.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/29.
//

public protocol ServiceType: AnyObject {
    init()
    
    func start()
    func stop()
}

public extension ServiceType {
    func start() {}
    func stop() {}
}
