//
//  AgoraRtcRepository.swift
//  Data
//
//  Created by 강현준 on 2023/09/11.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift
import Foundation
import Domain

public struct AgoraRepository: AgoraRepositoryProtocol {
    
    private let agoraService: AgoraRtcServiceProtocol
    
    public init(agoraService: AgoraRtcServiceProtocol) {
        self.agoraService = agoraService
    }
    
    public func joinChannel() -> Observable<Bool> {
        return agoraService.joinChannel()
    }
    
    public func observeDidJoinOfUser() -> Observable<VideoCallUser> {
        return agoraService.agoraKit.rx.didJoinedOfUid()
            .map { uid in
                let newUser = VideoCallUser(uid: uid)
                
                return newUser
            }
            .compactMap { $0 }
    }
    
    public func observeDidOfflineOfUid() -> Observable<UInt> {
        return agoraService.agoraKit.rx.didOfflineOfUid()
    }
    
    public func observeDidUserAudioMuteChanged() -> Observable<(muted: Bool, uid: UInt)> {
        return agoraService.agoraKit.rx.delegate.didAudioMutedSubject
    }
}
