//
//  DefaultMeetingCoordinator.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/08/30.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import BaseFeatureDependency
import Core
import Data
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
        
        AgoraRtcService.shared.setup(appID: "", channelID: "", token: "", uid: 0, clientRole: .broadcaster)
        
        
        viewModel.localUser.onNext(
            VideoCallUser(
                uid: 0,
                displayName: "나",
                isAudioMuted: false,
                isVideoMuted: false,
                isSpeaking: false)
        )
        
        meetingVC.bind(to: viewModel)
        
        self.navigationController.pushViewController(meetingVC, animated: true)
    }
    
    
}
