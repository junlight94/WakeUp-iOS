//
//  Coordinator.swift
//  BaseFeatureDependency
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import Core

public protocol Coordinator: AnyObject {
    
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    var navigationController: UINavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    var coordinatorType: CoordinatorType { get }
    
    func start()
    
    func finish()
}

public extension Coordinator {
    
    func finish() {
        childCoordinators.removeAll()
    }
}
