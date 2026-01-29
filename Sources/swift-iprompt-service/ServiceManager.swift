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
    
    private var services = [String: ServiceType]()
    private var lock = NSLock()
    
    open func installService<ServiceSpec: ServiceSpecType>(
        with serviceSpec: ServiceSpec
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let serviceId = serviceSpec.serviceIdentifier
        guard services[serviceId] == nil else { return }
        
        let service = serviceSpec.makeService()
        service.start()
        
        services[serviceId] = service
    }
    
    open func uninstallService<ServiceSpec: ServiceSpecType>(
        with serviceSpec: ServiceSpec
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        let serviceId = serviceSpec.serviceIdentifier
        guard let service = services[serviceId] else { return }
        
        service.stop()
        
        services.removeValue(forKey: serviceId)
    }
    
    open func uninstallAllServices() {
        lock.lock()
        defer { lock.unlock() }
        
        for (_, service) in services {
            service.stop()
        }
        services.removeAll()
    }
    
    open func getService<ServiceSpec: ServiceSpecType>(
        with serviceSpec: ServiceSpec
    ) -> ServiceSpec.Service? {
        lock.lock()
        defer { lock.unlock() }
        
        let serviceId = serviceSpec.serviceIdentifier
        return services[serviceId] as? ServiceSpec.Service
    }
}
