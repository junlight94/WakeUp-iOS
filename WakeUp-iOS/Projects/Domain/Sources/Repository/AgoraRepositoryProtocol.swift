//
//  AgoraRepositoryProtocol.swift
//  Domain
//
//  Created by 강현준 on 2023/09/11.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift

public protocol AgoraRepositoryProtocol {
    func joinChannel() -> Observable<Bool>
    func observeDidJoinOfUser() -> Observable<VideoCallUser>
    func observeDidOfflineOfUid() -> Observable<UInt>
    func observeDidUserAudioMuteChanged() -> Observable<VideoCallUserStatusChange>
    func observeDidUserVideoEnableChanged() -> Observable<VideoCallUserStatusChange>
    func observeAudioVolumeIndicationOfSpeakers() -> Observable<[VideoCallAudioVolumeInfo]>
    func leaveChannel() -> Observable<Void>
}
