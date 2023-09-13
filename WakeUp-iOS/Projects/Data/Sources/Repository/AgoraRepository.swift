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
    
    public func observeDidUserAudioMuteChanged() -> Observable<VideoCallUserStatusChange> {
        return agoraService.agoraKit.rx.delegate.didAudioMutedSubject
            .map {
                VideoCallUserStatusChange(uid: $0.uid, status: $0.muted)
            }
    }
    
    public func observeDidUserVideoEnableChanged() -> Observable<VideoCallUserStatusChange> {
        return agoraService.agoraKit.rx.delegate.didVideoEnabledSubject
            .map {
                VideoCallUserStatusChange(uid: $0.uid, status: $0.enabled)
            }
    }
    
    public func observeAudioVolumeIndicationOfSpeakers() -> Observable<[VideoCallAudioVolumeInfo]> {
        return agoraService.agoraKit.rx.reportAudioVolumeIndicationOfSpeakers()
            .map { $0.map{ $0.toDomain() } }
    }
    
    public func leaveChannel() -> Observable<Void> {
        return agoraService.leaveChannel()
    }
}
