//  AppDelegate+Extension.swift
//  ios-qube
//
//  Created by Junyoung Lee on 2023/08/17.
//  Copyright © 2023 Quriously. All rights reserved.
//

import Foundation
import Domain
import Network
import Data
import Core
import AgoraRtcKit

extension AppDelegate {
    var container: DIContainer {
        DIContainer.shared
    }
    
    func registerAgoraService(
        appID: String,
        channelID: String,
        token: String,
        uid: UInt,
        clientRole: AgoraClientRole
    ) {
        container.register(interface: AgoraRtcServiceProtocol.self, implement: { _ in
            AgoraRtcService.shared.setup(
                appID: appID,
                channelID: channelID,
                token: token, uid: uid,
                clientRole: clientRole
            )
            
            return AgoraRtcService.shared
        })
    }
    
    func registerAgoraUIInterface() {
        container.register(interface: AgoraUIServiceInterface.self, implement: { _ in
            return AgoraRtcService.shared
        })
    }

    func registerDependencies() {

//         MARK: - Repository
        container.register(interface: AgoraRepositoryProtocol.self) { resolver in
            guard let agoraService = resolver.resolve(AgoraRtcServiceProtocol.self) else {
                fatalError()
            }
            
            return AgoraRepository(
                agoraService: agoraService
            )
        }

        // MARK: - UseCase
        container.register(interface: JoinVideoCallUseCaseProtocol.self) { resolver in
            
            guard let agoraRepository = resolver.resolve(AgoraRepositoryProtocol.self) else {
                fatalError()
            }
            
            return JoinVideoCallUseCase(
                agoraRepository: agoraRepository
            )
        }
        
        container.register(interface: VideoCallUseCaseProtocol.self, implement: { resolver in
            
            guard let agoraRepository = resolver.resolve(AgoraRepositoryProtocol.self) else {
                fatalError()
            }
            
            return VideoCallUseCase(
                agoraRepository: agoraRepository
            )
        })
    }
}

