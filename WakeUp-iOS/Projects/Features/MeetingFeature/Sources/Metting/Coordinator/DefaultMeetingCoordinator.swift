//
//  DefaultMeetingCoordinator.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/08/30.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import Core
import Domain

import BaseFeatureDependency
import RxSwift

import AgoraRtcKit

public final class DefaultMeetingCoordinator: MeetingCoordinator {
    
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public var coordinatorType: CoordinatorType { .meeting }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let meetingVC = MeetingVC()
        let viewModel = MeetingViewModel()
        viewModel.coordinator = self
        
        viewModel.localUser.onNext(
            VideoCallUser(uid: 0)
        )
        
        meetingVC.bind(to: viewModel)
        
        self.navigationController.pushViewController(meetingVC, animated: true)
    }
    
    
}
