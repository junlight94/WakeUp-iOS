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
    
    let permissionrequest = PublishSubject<ResponseObserver>()
    let permissionresult = PublishSubject<Bool>()
    let setUpLocalVideo = PublishSubject<Void>()
    var alert = PublishSubject<Alert>()
    let permissionResultObserver = PublishSubject<Bool>()
    
    let joinChannelTrigger = PublishSubject<Void>()
    let joinChannelStart = PublishSubject<ChannelInformation>()
    
    var remoteUsers = BehaviorSubject<[VideoCallUser]>(value: [])
    let localUser = BehaviorSubject<VideoCallUser>(value: VideoCallUser(uid: 0, displayName: ""))
    
    let rtc = Rtc(appID: "e2f642e0bf04462fbcaf831501217b6a", channelId: "TEST5", token: "007eJxTYFh+QthF6fm6dbLvVk8zmpOWM+P8Do7L8zbr5+1b+FDdcOE8BYZUozQzE6NUg6Q0AxMTM6O0pOTENAtjQ1MDQyND8ySzxEn5X1MaAhkZGL3esgBJMATxWRlCXINDTBkYANMeIHw=", uid: 0)
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
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
        transformLocalUser()
        
        
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
                if result == true {
                    let alert = Alert(title: "입장 성공", message: "그룹 채팅 채널에 입장하였습니다.")
                    viewModel.alert.onNext(alert)
                } else {
                    let alert = Alert(title: "입장 실패", message: "입장에 실패했습니다.")
                    viewModel.alert.onNext(alert)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    // 내 정보 바인딩하고 내 마이크상태 연결하기
    func transformLocalUser() {
        rtc.agoraKit.rx.didJoinedOfUid()
            .subscribe(onNext: {
                print("DEBUG: didJoinedOfUid\($0)")
            })
            .disposed(by: disposeBag)
        
        
    }
}
