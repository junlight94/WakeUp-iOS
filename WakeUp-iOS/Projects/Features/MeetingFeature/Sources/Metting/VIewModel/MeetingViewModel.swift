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

// MARK: - TEST
import Domain // UseCase
import Core // DIContainer
import Data // SingleTon AgoraService

final class MeetingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: MeetingCoordinator?
    
    let permissionresult = PublishSubject<Bool>()
    let permissionResultObserver = PublishSubject<Bool>()
    let joinChannelTrigger = PublishSubject<Void>()
    let channelJoinned = BehaviorSubject<Bool>(value: false)
    
    let joinChannelUseCase: JoinVideoCallUseCaseProtocol = DIContainer.shared.resolve(JoinVideoCallUseCaseProtocol.self)
    let videoCallUseCase: VideoCallUseCaseProtocol = DIContainer.shared.resolve(VideoCallUseCaseProtocol.self)

    // MARK: - Output
    
    let permissionrequest = PublishSubject<ResponseObserver>()
    let setUpLocalVideo = PublishSubject<Void>()
    var alert = PublishSubject<Alert>()
    let localUser = BehaviorSubject<VideoCallUser>(value: VideoCallUser(uid: 0))
    var remoteUsers = BehaviorSubject<[VideoCallUser]>(value: [])
    
    // MARK: - ViewModelInput
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let localUserAudioTapped: Observable<Void>
        let localUserVideoTapped: Observable<Void>
        let viewDidDisappear: Observable<Void>
        let leaveButtonTapped: Observable<Void>
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
//        transformLeaveChannel(input: input)
        
        return Output(
            checkUserPermission: permissionrequest.asSignal(onErrorSignalWith: .empty()),
            setupLocalVideo: setUpLocalVideo.asSignal(onErrorSignalWith: .empty()),
            alert: alert.asSignal(onErrorSignalWith: .empty()),
            localUser: localUser.asDriver(onErrorJustReturn: VideoCallUser(uid: 0)),
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
            .flatMap { $0.0.joinChannelUseCase.joinChannel() }
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
//        input
//            .viewDidDisappear
//            .withUnretained(self)
//            .subscribe(onNext: { viewModel, _ in
//                print("DEBUG: LeaveChannel@@@@@@")
//                viewModel.rtc.leaveChannel()
//            })
//            .disposed(by: disposeBag)
//
//        input.leaveButtonTapped
//            .withUnretained(self)
//            .subscribe(onNext: { viewModel, _ in
//                print("DEBUG: LeaveChannel@@@@@@")
//                viewModel.rtc.leaveChannel()
//            })
//            .disposed(by: disposeBag)
    }
    
    func transformLocalUser(input: Input) {
        
        localUser
            .map { (audio: $0.isAudioMuted, video: $0.isVideoMuted) }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, status in
                print("DEBUG: audioStatus: \(status.audio), videoStatus: \(status.video)")
                
                AgoraRtcService.shared.agoraKit.enableLocalAudio(!status.audio)
                AgoraRtcService.shared.agoraKit.enableLocalVideo(!status.video)
            })
            .disposed(by: disposeBag)
        
        input.localUserAudioTapped
            .withLatestFrom(localUser)
            .withUnretained(self)
            .subscribe(onNext: {viewModel, user in
                print("DEBUG: LocalUserAudioButtonTapped")
                var newUser = user
                newUser.isAudioMuted.toggle()
                viewModel.localUser.onNext(newUser)
            })
            .disposed(by: disposeBag)

        input.localUserVideoTapped
            .withLatestFrom(localUser)
            .withUnretained(self)
            .subscribe(onNext: {viewModel, user in
                print("DEBUG: LocalUserVideoButtonTapped")
                var newUser = user
                newUser.isVideoMuted.toggle()
                viewModel.localUser.onNext(newUser)
            })
            .disposed(by: disposeBag)
    }
    
    func transformRemoteUser() {
        
        let remoteUserJoindOfUser = self.channelJoinned
            .filter { $0 == true }
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.videoCallUseCase.observeDidJoinOfUser()
            }
            
        remoteUserJoindOfUser
            .withLatestFrom(
                Observable.combineLatest(remoteUserJoindOfUser, remoteUsers)
            )
            .withUnretained(self)
            .subscribe(onNext: { viewModel, combine in
                let newUser = combine.0
                var remoteUsers = combine.1
                print("DEBUG: newUserJoined = \(newUser)")
                remoteUsers.append(newUser)
                viewModel.remoteUsers.onNext(remoteUsers)
            })
            .disposed(by: disposeBag)
            
        let remoteUserOfflineOfUid = self.channelJoinned
            .filter { $0 == true }
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.videoCallUseCase.observeDidOfflineOfUid()
            }
        
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
        
        let remoteUserAudioMuteChanged = self.channelJoinned
            .filter { $0 == true }
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.videoCallUseCase.observeDidUserAudioMuteChanged()
            }
        
        remoteUserAudioMuteChanged
            .withLatestFrom(Observable.combineLatest(remoteUserAudioMuteChanged, remoteUsers))
            .withUnretained(self)
            .subscribe(onNext: { viewModel, combine in
                let audioChangedUserUid = combine.0.uid
                let audioChangedValue = combine.0.muted
                
                var remoteUsers = combine.1
                
                if let changedUserIndex = remoteUsers.firstIndex(where: { $0.uid == audioChangedUserUid}) {
                    remoteUsers[changedUserIndex].isAudioMuted = audioChangedValue
                    
                    if audioChangedValue == true {
                        remoteUsers[changedUserIndex].isSpeaking = false
                    }
                }
                
                viewModel.remoteUsers.onNext(remoteUsers)
            })
            .disposed(by: disposeBag)
        
//        let videoEnableChanged = rtc.agoraKit.rx.delegate.didVideoEnabledSubject
//
//        videoEnableChanged
//            .withLatestFrom(
//                Observable.combineLatest(videoEnableChanged, remoteUsers)
//            )
//            .withUnretained(self)
//            .subscribe(onNext: { viewModel, combine in
//                let videoChangedUserUid = combine.0.uid
//                let videoChangedValue = combine.0.enabled
//
//                var remoteUsers = combine.1
//
//                if let changedUserIndex = remoteUsers.firstIndex(where: { $0.uid == videoChangedUserUid }) {
//                    remoteUsers[changedUserIndex].isVideoMuted = videoChangedValue
//                }
//
//                viewModel.remoteUsers.onNext(remoteUsers)
//            })
//            .disposed(by: disposeBag)
//
//
//        let speaking = rtc.agoraKit.rx.reportAudioVolumeIndicationOfSpeakers()
//            .map { $0.sorted(by: { $0.uid < $1.uid }) }
//
//        let localUserSpeaking = speaking
//            .map {
//                return $0.filter { $0.uid == 0 }
//            }
//            .map { $0.first }
//            .compactMap { $0 }
//            .map { return [$0.uid, $0.vad] }
//            .distinctUntilChanged()
//
//        let remoteUser = speaking
//            .map { users in
//                let lastIndex = users.count - 1
//
//                return users[1...lastIndex]
//            }
//
//        localUserSpeaking
//            .withLatestFrom(
//                Observable.combineLatest(localUserSpeaking, localUser)
//            )
//            .withUnretained(self)
//            .subscribe(onNext: { viewModel, combine in
//                let speakingUserUid = combine.0[0]
//                let speakingUserValue = combine.0[1] == 0 ? false : true
//
//                var localUserData = combine.1
//
//                localUserData.isSpeaking = speakingUserValue
//
//                print(localUserData)
//
//                viewModel.localUser.onNext(localUserData)
//            })
//            .disposed(by: disposeBag)
    }
    
    func transformSpeaking() {
        
    }
}
