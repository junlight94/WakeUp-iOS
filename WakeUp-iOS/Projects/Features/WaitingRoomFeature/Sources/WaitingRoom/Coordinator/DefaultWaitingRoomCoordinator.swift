//
//  DefaultWaitingRoomCoordinator.swift
//  WaitingRoomFeature
//
//  Created by 강현준 on 2023/08/29.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import BaseFeatureDependency
import Core

public final class DefaultWaitingRoomCoordinator: WaitingRoomCoordinator {
    
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public var coordinatorType: CoordinatorType { .waitingRoom }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let waitingRoomVC = WaitingRoomVC()
        let viewModel = WaitingRoomViewModel()
        
        viewModel.coordinator = self
        
        self.navigationController.pushViewController(waitingRoomVC, animated: true)
    }
    
    
}
