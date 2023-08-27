//
//  AppCoordinator.swift
//  RootFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public protocol AppCoordinator: Coordinator {
    func signinFlow()
    
    func meetingFlow()
    
    func waitingRoomFlow()
}
