//
//  MeetingViewModel.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/08/30.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift
import RxCocoa
import BaseFeatureDependency

import AgoraRtcKit

struct VideoCallUser {
    let uid: UInt
    let displayName: String
    var isAudioMuted: Bool
    var isVideoMuted: Bool
    var isSpeaking: Bool
    
    init(uid: UInt, displayName: String) {
        self.uid = uid
        self.displayName = displayName
        self.isAudioMuted = false
        self.isVideoMuted = false
        self.isSpeaking = false
    }
    
    init(uid: UInt, displayName: String, isAudioMuted: Bool, isVideoMuted: Bool, isSpeaking: Bool) {
        self.uid = uid
        self.displayName = displayName
        self.isAudioMuted = isAudioMuted
        self.isVideoMuted = isVideoMuted
        self.isSpeaking = isSpeaking
    }
}

struct ChannelInformation {
    var appID: String
    var channelName: String
    var tempToken: String
}

final class MeetingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: MeetingCoordinator?
    
    let permissionresult = PublishSubject<Bool>()
    let permissionResultObserver = PublishSubject<Bool>()
    let joinChannelTrigger = PublishSubject<Void>()
    let channelJoinned = BehaviorSubject<Bool>(value: false)

    // MARK: - Output
    
    let permissionrequest = PublishSubject<ResponseObserver>()
    let setUpLocalVideo = PublishSubject<Void>()
    var alert = PublishSubject<Alert>()
    let localUser = BehaviorSubject<VideoCallUser>(value: VideoCallUser(uid: 0, displayName: ""))
    var remoteUsers = BehaviorSubject<[VideoCallUser]>(value: [])
    
    let rtc = Rtc(appID: "e2f642e0bf04462fbcaf831501217b6a", channelId: "TEST7", token: "007eJxTYFhwZ0J8cF0PP4ct1+2OyrjIK+HvYnf/Sl/DznF79qcT6bcUGFKN0sxMjFINktIMTEzMjNKSkhPTLIwNTQ0MjQzNk8wS3/36ltIQyMjQEv6OkZEBAkF8VoYQ1+AQcwYGAM0MIZU=", uid: 0)
    
    // TODO: - Rtc에 이상한 channelId랑 token 넣어도 result가 0으로 나옴..
//    let rtc = Rtc(appID: "e2f642e0bf04462fbcaf831501217b6a", channelId: "TEdf", token: "007eJxTYFhwZ0J8cF0PP4ct1+4123+HvYnf/SljNKSkhPTLIwNTQ0MjQzNk8wS3/36ltIQyMjQEv6OkZEBAkF8VoYQ1+AQcwYGAM0MIZU=", uid: 0)
    
    // MARK: - ViewModelInput
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let localUserAudioTapped: Observable<Void>
        let localUserVideoTapped: Observable<Void>
        let viewDidDisappear: Observable<Void>
    }
    
    // MARK: - ViewModelOutput
    
    struct Output {
        let checkUserPermission: Signal<ResponseObserver>
        let setupLocalVideo: Signal<Void>
        let alert: Signal<Alert>
        let localUser: Driver<VideoCallUser>
        let remoteUsers: Driver<[VideoCallUser]>
    }
    
    func transform(input: Input) -> Output {
        transformPermission(input: input)
        transformJoinChannel(input: input)
        transformLocalUser(input: input)
        transformRemoteUser()
        transformLeaveChannel(input: input)
        
        return Output(
            checkUserPermission: permissionrequest.asSignal(onErrorSignalWith: .empty()),
            setupLocalVideo: setUpLocalVideo.asSignal(onErrorSignalWith: .empty()),
            alert: alert.asSignal(onErrorSignalWith: .empty()),
            localUser: localUser.asDriver(onErrorJustReturn: VideoCallUser(uid: 0, displayName: "")),
            remoteUsers: remoteUsers.asDriver(onErrorJustReturn: [])
        )
    }
    
    func transformPermission(input: Input) {
        
        input.viewDidLoad
            .withUnretained(self)
            .map {
                ResponseObserver(
                    observer: $0.0.permissionResultObserver.asObserver()
                )
            }
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.permissionrequest.onNext($0.1)
            })
            .disposed(by: disposeBag)
        
        permissionResultObserver
            .bind(to: permissionresult)
            .disposed(by: disposeBag)
        
        permissionresult
            .withUnretained(self)
            .subscribe(onNext: {
                if $0.1 == true {
                    $0.0.setUpLocalVideo.onNext(())
                    $0.0.joinChannelTrigger.onNext(())
                } else {
                    let alert = Alert(title: "권한이 필요합니다", message: "마이크, 카메라 권한이필요합니다. 서버에 연결할 수 없습니다.")
                    $0.0.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func transformJoinChannel(input: Input) {
        joinChannelTrigger
            .withUnretained(self)
            .flatMap { (viewModel, _) in
                viewModel.rtc.joinChannel()
            }
            .withUnretained(self)
            .subscribe(onNext: { (viewModel, result) in
                print("DEBUG: JoinChannelResult \(result)")
                if result == true {
                    let alert = Alert(title: "입장 성공", message: "그룹 채팅 채널에 입장하였습니다.")
                    viewModel.alert.onNext(alert)
                    viewModel.channelJoinned.onNext(true)
                } else {
                    let alert = Alert(title: "입장 실패", message: "입장에 실패했습니다.")
                    viewModel.alert.onNext(alert)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func transformLeaveChannel(input: Input) {
        input
            .viewDidDisappear
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.rtc.leaveChannel()
            })
            .disposed(by: disposeBag)
    }
    
    func transformLocalUser(input: Input) {
        
        localUser
            .map { (audio: $0.isAudioMuted, video: $0.isVideoMuted) }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, status in
                print("DEBUG: audioStatus: \(status.audio), videoStatus: \(status.video)")
                viewModel.rtc.agoraKit.enableLocalAudio(!status.audio)
                viewModel.rtc.agoraKit.enableLocalVideo(!status.video)
            })
            .disposed(by: disposeBag)
        
        input.localUserAudioTapped
            .withLatestFrom(localUser)
            .withUnretained(self)
            .subscribe(onNext: {viewModel, user in
                
                var newUser = user
                newUser.isAudioMuted.toggle()
                viewModel.localUser.onNext(newUser)
            })
            .disposed(by: disposeBag)
        
        input.localUserVideoTapped
            .withLatestFrom(localUser)
            .withUnretained(self)
            .subscribe(onNext: {viewModel, user in
                
                var newUser = user
                newUser.isVideoMuted.toggle()
                viewModel.localUser.onNext(newUser)
            })
            .disposed(by: disposeBag)
    }
    
    func transformRemoteUser() {
        
        let remoteUserJoinedOfUid = rtc.agoraKit.rx.didJoinedOfUid()
        
        remoteUserJoinedOfUid
            .withLatestFrom(
                Observable.combineLatest(remoteUserJoinedOfUid, remoteUsers)
            )
            .withUnretained(self)
            .subscribe(onNext: { viewModel, combine in
                let newUserUid = combine.0
                let newUser = VideoCallUser(uid: newUserUid, displayName: "")
                var remoteUsers = combine.1
                remoteUsers.append(newUser)
                
                viewModel.remoteUsers.onNext(remoteUsers)
            })
            .disposed(by: disposeBag)
        
        let remoteUserOfflineOfUid = rtc.agoraKit.rx.didOfflineOfUid()
        
        remoteUserOfflineOfUid
            .withLatestFrom(
                Observable.combineLatest(remoteUserOfflineOfUid, remoteUsers)
            )
            .withUnretained(self)
            .subscribe(onNext: { viewModel, combine in
                let offlineUserUid = combine.0
            
                var remoteUsers = combine.1
                
                if let offlineUserIndex = remoteUsers.firstIndex(where: { $0.uid == offlineUserUid}) {
                    remoteUsers.remove(at: offlineUserIndex)
                }
                
                viewModel.remoteUsers.onNext(remoteUsers)
            })
            .disposed(by: disposeBag)
        
    }
}
