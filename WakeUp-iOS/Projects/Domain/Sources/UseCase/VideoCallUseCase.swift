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
    func observeDidUserAudioMuteChanged() -> Observable<(muted: Bool, uid: UInt)>
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
    
    public func observeDidUserAudioMuteChanged() -> Observable<(muted: Bool, uid: UInt)> {
        return agoraRepository.observeDidUserAudioMuteChanged()
    }
}
