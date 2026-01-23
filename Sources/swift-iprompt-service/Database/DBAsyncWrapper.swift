//
//  DBAsyncWrapper.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/23.
//

import Foundation

internal struct DBAsyncWrapper<Base> {
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

internal protocol DBAsyncCompatible {}
internal extension DBAsyncCompatible {
    var async: DBAsyncWrapper<Self> {
        return DBAsyncWrapper(self)
    }
}


