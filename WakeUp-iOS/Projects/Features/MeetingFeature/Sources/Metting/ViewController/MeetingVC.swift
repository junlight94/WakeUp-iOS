//
//  MeetingVC.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/08/30.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import BaseFeatureDependency
import Core
import Then
import FlexLayout
import PinLayout
import DSKit

import AgoraRtcKit
import AVFoundation

import RxSwift
import RxCocoa

struct VideoCallUser {
    let uid: UInt
    let displayName: String
    var isAudioMuted: Bool
    var isVideoMuted: Bool
    var isSpeaking: Bool
}

class MeetingVC: BaseVC, ViewModelBindable {
    
    let baseflexContainer = BaseFlexScrollableView(mode: .adjustHeight)
    
    let mainView = MeetingMainView(mode: .adjustHeight)
    
    var viewModel: MeetingViewModel?
    let disposeBag = DisposeBag()
    
    let appID = "e2f642e0bf04462fbcaf831501217b6a"
    var agoraEngine: AgoraRtcEngineKit?
    let tempToken: String? = "007eJxTYDAxe3Hyq1qia4LbkdYFt1tTGc6pVb2f8v7UHr/iJSFnOw8oMKQapZmZGKUaJKUZmJiYGaUlJSemWRgbmhoYGhmaJ5kl3m75ktIQyMgQsjaTgREKQXxWhhDX4BATBgYABb0hlQ=="
    var userID: UInt = 0
    var userName: String? = nil
    var channelName = "TEST4"
    var remoteUserIDs: [UInt] = []
    var userRole: AgoraClientRole = .broadcaster
    var joined: Bool = false {
        didSet {
            DispatchQueue.main.async {
                
            }
        }
    }
    func setupLocalVideo() {
        agoraEngine?.enableVideo()
        agoraEngine?.startPreview()
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = mainView.myVideoContainer.videoLayer
        
        
        agoraEngine?.setupLocalVideo(videoCanvas)
    }
    override func loadView() {
        self.view = mainView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.setDelegate(self)
        initalizeAgoraEngine()
        
//        Task {
//            await joinChannel()
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        leaveChannel()
    }
    
    func requestPermission(type: AVMediaType,completion: @escaping(Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AVCaptureDevice.requestAccess(for: type, completionHandler: completion)
        }
    }
 
 
    
    func showMessage(title: String, text: String, delay: Int = 2) -> Void {
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            self.present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        })
    }

    func initalizeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        config.appId = appID
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: nil)
    }
    
    func joinChannel() async {
        
        let option = AgoraRtcChannelMediaOptions()
        
        if self.userRole == .broadcaster {
            option.clientRoleType = .broadcaster
        } else {
            option.clientRoleType = .audience
        }
        
        option.channelProfile = .communication
        
        let resutl = agoraEngine?.joinChannel(byToken: tempToken, channelId: channelName, uid: 0, mediaOptions: option, joinSuccess: { channel, uid, elapsed in
            
        })
        
        if resutl == 0 {
            joined = true
            showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
        }
    }
    
    func leaveChannel() {
        agoraEngine?.leaveChannel(nil)
        mainView.myVideoContainer
        remoteUserIDs.removeAll()
        mainView.collectionView.reloadData()
    }
    
    
    
  
    func bindViewModel() {
        let input = MeetingViewModel.Input(viewDidLoad: rx.viewWillAppar.take(1).map { _ in ()})
        
        let output = viewModel?.transform(input: input)
        
        output?.checkUserPermission
            .emit(to: rx.requestCameraAndMicPermission)
            .disposed(by: disposeBag)
        
        output?.setUpLocalVideo
            .do(onNext: { print("DEBUG: StartSetupLocalVideo") })
            .emit(to: rx.setUpLocalVideo)
            .disposed(by: disposeBag)
        
        output?.permissionDenied
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
        
        
        agoraEngine?.rx.didJoinedOfUid()
            .subscribe(onNext: {
                print("DEBUG: didJoindOfUID = \($0)")
                self.remoteUserIDs.append($0)
                self.mainView.collectionView.reloadData()
            })
                .disposed(by: disposeBag)
        
        agoraEngine?.rx.didOfflineOfUid()
            .subscribe(onNext: {
                print("DEBUG: didOfflineOfUid = \($0)")
                self.remoteUserIDs.append($0)
                self.mainView.collectionView.reloadData()
            })
                .disposed(by: disposeBag)

    }
    
 
}

//extension MeetingVC: AgoraRtcEngineDelegate {
//    // 새로운 참여자가 채널에 참여할 때 호출
//
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
//        remoteUserIDs.append(uid)
//        mainView.collectionView.reloadData()
//    }
//
//    // 사용자가 채널을 떠날 때 호출
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
//        if let index = remoteUserIDs.firstIndex(where: { $0 == uid }) {
//            remoteUserIDs.remove(at: index)
//            mainView.collectionView.reloadData()
//        }
//    }
//
//    // 누군가 Audio를 Mute하면 호출
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
//
//    }
//
//    // 누군가 Video의 상태를 변경하면 호출
//    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState, reason: AgoraVideoRemoteReason, elapsed: Int) {
//
//    }
//
//    // 누군가 말을 하면 호출
//    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
//
//    }
//}

extension MeetingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return remoteUserIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingCollectionViewCell.identifier, for: indexPath) as? MeetingCollectionViewCell else { return UICollectionViewCell() }
        
        let remoteID = remoteUserIDs[indexPath.row]
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = remoteID
        videoCanvas.view = cell.groupCallContainer
        videoCanvas.renderMode = .fit
        agoraEngine?.setupRemoteVideo(videoCanvas)
        
        
        
        if let userInfo = agoraEngine?.getUserInfo(byUid: remoteID, withError: nil),
           let username = userInfo.userAccount {
//            cell.nameLabel.text = username
        } else {
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = view.frame.size.width
        let itemSize = (screenWidth - 16 - 16 - 16) / 2
        
        return CGSize(width: itemSize, height: itemSize)
    }
}

struct ResponseObserver {
    let observer: AnyObserver<Bool>
}

extension Reactive where Base: MeetingVC {
    var requestCameraAndMicPermission: Binder<ResponseObserver> {
        return Binder(base) { base, observer in
            let cameraPermission: Observable<Bool> = Observable.create { emitter in
                
                base.requestPermission(type: .video, completion: { bool in
                    emitter.onNext(bool)
                    emitter.onCompleted()
                } )
                return Disposables.create()
            }
            
            let micPermission: Observable<Bool> = Observable.create { emitter in
                
                base.requestPermission(type: .audio, completion: { bool in
                    emitter.onNext(bool)
                    emitter.onCompleted()
                })
                return Disposables.create()
            }
            
            Observable.concat(cameraPermission, micPermission)
                .reduce(true, accumulator: { accValue, newValue in
                    return accValue && newValue
                })
                .subscribe(onNext: { result in
                    observer.observer.onNext(result)
                }
                , onCompleted: {
                    observer.observer.onCompleted()
                })
                .disposed(by: base.disposeBag)
        }
    }
    
    var setUpLocalVideo: Binder<Void> {
        return Binder(base) { base, _ in
            base.setupLocalVideo()
        }
    }
}


