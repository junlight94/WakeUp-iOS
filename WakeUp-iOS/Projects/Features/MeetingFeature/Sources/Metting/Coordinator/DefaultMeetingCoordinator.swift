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
        let meetingVC = MeetingVC(agoraUIService: DIContainer.shared.resolve(AgoraUIServiceInterface.self))
        let viewModel = MeetingViewModel(
            joinChannelUseCase: DIContainer.shared.resolve(JoinVideoCallUseCaseProtocol.self),
            videoCallUseCase: DIContainer.shared.resolve(VideoCallUseCaseProtocol.self),
            agoraUIService: DIContainer.shared.resolve(AgoraUIServiceInterface.self)
        )
        viewModel.coordinator = self
        
        // User를 받아서, localUser 생성 후 viewModel.localUser.onNext
        
        viewModel.localUser.onNext(
            VideoCallUser(uid: 0)
        )
        
        meetingVC.bind(to: viewModel)
        
        self.navigationController.pushViewController(meetingVC, animated: true)
    }
    
    
}
