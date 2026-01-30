//
//  ServiceManager.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/29.
//

import Foundation

open class ServiceManager: @unchecked Sendable {
    public static let shared = ServiceManager()
    private init() {}
    
    private var lock = NSLock()
    private var services = [String: ServiceType]()
    
    @discardableResult
    open func install<Service: ServiceType>(_ serviceType: Service.Type) -> Service {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: serviceType.self)
        if let existingService = services[key] as? Service {
            return existingService
        }
        
        let service = Service()
        service.start()
        
        services[key] = service
        return service
    }
    
    open func uninstall<Service: ServiceType>(_ serviceType: Service.Type) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: serviceType.self)
        guard let service = services[key] else {
            return
        }
        
        service.stop()
        
        services.removeValue(forKey: key)
    }
    
    open func uninstallAllServices() {
        lock.lock()
        defer { lock.unlock() }
        
        for (_, service) in services {
            service.stop()
        }
        services.removeAll()
    }
    
    open func getService<Service: ServiceType>(_ serviceType: Service.Type) -> Service? {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: serviceType.self)
        guard let service = services[key] as? Service else {
            return nil
        }
        return service
    }
}
