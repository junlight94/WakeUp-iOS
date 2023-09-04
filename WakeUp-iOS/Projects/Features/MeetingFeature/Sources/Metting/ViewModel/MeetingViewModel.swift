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
import AVFoundation

struct ChannelInformation {
    var appID: String
    var channelName: String
    var tempToken: String
}

final class MeetingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: MeetingCoordinator?
    
    let appID = <String>()
    let channelName = PublishSubject<String>()
    let tempToken = PublishSubject<String>()
    
    let permissionrequest = PublishSubject<ResponseObserver>()
    let permissionresult = PublishSubject<Bool>()
    let setUpLocalVideo = PublishSubject<Void>()
    var permissionDeniedAlert = PublishSubject<Alert>()
    let permissionResultObserver = PublishSubject<Bool>()
    
    let joinChannelStart = PublishSubject<Void>()
    let joinChannelInformation = PublishSubject<Void>()
    
    var videoCallUsers = BehaviorSubject<[VideoCallUser]>(value: [])
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let checkUserPermission: Signal<ResponseObserver>
        let setUpLocalVideo: Signal<Void>
        let permissionDenied: Signal<Alert>
    }
    
    func transform(input: Input) -> Output {
        transformPermission(input: input)
        transformJoinChannel(input: input)
        
        
        return Output(
            
            checkUserPermission: permissionrequest.asSignal(onErrorSignalWith: .empty()),
            setUpLocalVideo: setUpLocalVideo.asSignal(onErrorSignalWith: .empty()),
            permissionDenied: permissionDeniedAlert.asSignal(onErrorSignalWith: .empty())
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
                    $0.0.joinChannelStart.onNext(())
                } else {
                    let alert = Alert(title: "권한이 필요합니다", message: "마이크, 카메라 권한이필요합니다. 서버에 연결할 수 없습니다.")
                    $0.0.permissionDeniedAlert.onNext(alert)
                }
                
                print("DEBUG: 권한 검사 결과 : \($0.1)")
            })
            .disposed(by: disposeBag)
    }
    
    func transformJoinChannel(input: Input) {
        // JoinChannelStart가 들어오면joinChannelInformation가 방출할 APPID.. 등등 구조체 만들기(ChannelInformation예시 확인 후 확정)
        joinChannelStart
            .withLatestFrom( Observable.combineLatest(appID, channelName,tempToken))
          
    }
}
