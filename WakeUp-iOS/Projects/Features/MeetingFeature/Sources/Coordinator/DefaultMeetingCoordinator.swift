//
//  DefaultMeetingCoordinator.swift
//  MeetingFeature
//
//  Created by Junyoung on 2023/09/02.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency

public final class DefaultMeetingCoordinator: MeetingCoordinator {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public var coordinatorType: CoordinatorType {.meeting}
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = MeetingRoomVC()
        let viewModel = MeetingRoomViewModel()
        
        viewController.bind(to: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
