//
//  DefaultAppCoordinator.swift
//  RootFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import Core
import BaseFeatureDependency
import SigninFeature
import WaitingRoomFeature
import MeetingFeature

public final class DefaultAppCoordinator: AppCoordinator {
    
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public var coordinatorType: CoordinatorType { .app }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    public func start() {
//        let signinCoordinator = DefaultSigninCoordinator(self.navigationController)
        self.finishDelegate = self
//        self.childCoordinators.append(signinCoordinator)
//        signinCoordinator.start()
        
        
//        let waitingRoomCoordinator = DefaultWaitingRoomCoordinator(self.navigationController)
//        self.finishDelegate = self
//        self.childCoordinators.append(waitingRoomCoordinator)
//        waitingRoomCoordinator.start()
        
        let meetingCoordinator = DefaultMeetingCoordinator(self.navigationController)
        self.childCoordinators.append(meetingCoordinator)
        meetingCoordinator.start()
    }
    
    public func signinFlow() {
        
    }
    
    public func meetingFlow() {
        
    }
    
    public func waitingRoomFlow() {
        
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.coordinatorType {
        case .signin:
            signinFlow()
        case .meeting:
            meetingFlow()
        case .waitingRoom:
            waitingRoomFlow()
        default: break
        }
    }
}
