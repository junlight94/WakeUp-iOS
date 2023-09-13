//
//  VideoCallUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/09/12.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation
import RxSwift

public protocol VideoCallUseCaseProtocol {
    func observeDidJoinOfUser() -> Observable<VideoCallUser>
    func observeDidOfflineOfUid() -> Observable<UInt>
    func observeDidUserAudioMuteChanged() -> Observable<VideoCallUserStatusChange>
    func observeDidUserVideoEnableChanged() -> Observable<VideoCallUserStatusChange>
    func observeAudioVolumeIndicationOfSpeakers() -> Observable<[VideoCallAudioVolumeInfo]>
    func leaveChannel() -> Observable<Void>
}

public struct VideoCallUseCase: VideoCallUseCaseProtocol {
    
    private let agoraRepository: AgoraRepositoryProtocol
    
    public init(agoraRepository: AgoraRepositoryProtocol) {
        self.agoraRepository = agoraRepository
    }
    
    public func observeDidJoinOfUser() -> Observable<VideoCallUser> {
        return agoraRepository.observeDidJoinOfUser()
    }
    
    public func observeDidOfflineOfUid() -> Observable<UInt> {
        return agoraRepository.observeDidOfflineOfUid()
    }
    
    public func observeDidUserAudioMuteChanged() -> Observable<VideoCallUserStatusChange> {
        return agoraRepository.observeDidUserAudioMuteChanged()
    }
    
    public func observeDidUserVideoEnableChanged() -> Observable<VideoCallUserStatusChange> {
        return agoraRepository.observeDidUserVideoEnableChanged()
    }
    
    public func observeAudioVolumeIndicationOfSpeakers() -> Observable<[VideoCallAudioVolumeInfo]> {
        return agoraRepository.observeAudioVolumeIndicationOfSpeakers()
    }
    
    public func leaveChannel() -> Observable<Void> {
        return agoraRepository.leaveChannel()
    }
}
