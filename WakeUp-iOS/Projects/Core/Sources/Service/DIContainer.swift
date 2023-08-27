//
//  DIContainer.swift
//  Core
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation

import Swinject

public final class DIContainer {
    public static let shared = DIContainer()
    
    private let container: Container
    
    private init() {
        container = Container()
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        return container.resolve(serviceType)!
    }
    
    public func register<T>(interface: T.Type, implement: @escaping ((Resolver) -> T)) {
        container.register(interface, factory: implement)
    }
}
