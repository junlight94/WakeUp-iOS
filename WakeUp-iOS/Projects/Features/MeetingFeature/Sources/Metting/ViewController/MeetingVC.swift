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



class MeetingVC: BaseVC, ViewModelBindable {
    
    let baseflexContainer = BaseFlexScrollableView(mode: .adjustHeight)
    
    let mainView = MeetingMainView(mode: .adjustHeight)
    
    var viewModel: MeetingViewModel?
    let disposeBag = DisposeBag()
    
    var remoteUserIDs: [UInt] = []
    
    override func loadView() {
        self.view = mainView
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.setDelegate(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //        leaveChannel()
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
    
    //    func leaveChannel() {
    //        agoraEngine?.leaveChannel(nil)
    //        mainView.myVideoContainer
    //        remoteUserIDs.removeAll()
    //        mainView.collectionView.reloadData()
    //    }
    
    
    func apply(canvas: AgoraRtcVideoCanvas, toView view: UIView?, isLocal: Bool) {
        if canvas.view == view { return }
        
        canvas.view = view
        
        if isLocal {
            viewModel?.rtc.agoraKit.setupLocalVideo(canvas)
        } else {
            viewModel?.rtc.agoraKit.setupRemoteVideo(canvas)
        }
    }
    
    func bindViewModel() {
        let input = MeetingViewModel.Input(viewDidLoad: rx.viewWillAppar.take(1).map { _ in ()})
        
        guard let output = viewModel?.transform(input: input) else { return }
        
        output.checkUserPermission
            .emit(to: rx.requestCameraAndMicPermission)
            .disposed(by: disposeBag)
        
        output.setupLocalVideo
            .emit(onNext: { [weak self] _ in
                guard let self = self,
                      let canvas = self.viewModel?.rtc.createCanvas(uid: 0) else { return }
                
                self.apply(canvas: canvas, toView: self.mainView.myVideoContainer.videoLayer, isLocal: true)
            })
            .disposed(by: disposeBag)

        output.alert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
        
        output.localUser
            .do(onNext: { print("DEBUG: localUserBind \($0)") })
            .drive(mainView.myVideoContainer.rx.videoCallUser)
                .disposed(by: disposeBag)
                
                
                
                //                            agoraEngine?.rx.didJoinedOfUid()
                //                            .subscribe(onNext: {
                //                                print("DEBUG: didJoindOfUID = \($0)")
                //                                self.remoteUserIDs.append($0)
                //                                self.mainView.collectionView.reloadData()
                //                            })
                //                            .disposed(by: disposeBag)
                //
                //                            agoraEngine?.rx.didOfflineOfUid()
                //                            .subscribe(onNext: {
                //                                print("DEBUG: didOfflineOfUid = \($0)")
                //                                self.remoteUserIDs.remove(at: self.remoteUserIDs.firstIndex(of: $0) ?? 0)
                //                                self.mainView.collectionView.reloadData()
                //                            })
                //                            .disposed(by: disposeBag)
                //
                //                            let volumeIndication = agoraEngine?.rx.reportAudioVolumeIndicationOfSpeakers()
                //
                //        volumeIndication?
                //            .subscribe(onNext: { speakers in
                //                for speaker in speakers {
                //                    if speaker.uid == 0 {
                //                        if speaker.vad == 1 {
                //                            print("DEBUG: Speaking \(speaker)")
                //                        } else {
                //                            print("DEBUG: Don't Speaking \(speaker)")
                //                        }
                //
                //                    } else {
                //
                //                    }
                //                }
                //            })
                
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
        //        agoraEngine?.setupRemoteVideo(videoCanvas)
        
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
    
    //    var initAgoraEngine: Binder<String> {
    //        return Binder(base) { base, appID in
    //            let config = AgoraRtcEngineConfig()
    //            config.appId = appID
    //            base.agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: nil)
    //            base.agoraEngine?.enableAudioVolumeIndication(300, smooth: 5, reportVad: true)
    //        }
    //    }
    
    
    var joinChannel: Binder<ChannelInformation> {
        return Binder(base) { base, channelInfo in
            //            let option = AgoraRtcChannelMediaOptions()
            //
            //            if base.userRole == .broadcaster {
            //                option.clientRoleType = .broadcaster
            //            } else {
            //                option.clientRoleType = .audience
            //            }
            //
            //            option.channelProfile = .communication
            //
            //            let result = base.agoraEngine?.joinChannel(byToken: channelInfo.tempToken, channelId: channelInfo.channelName, uid: 0, mediaOptions: option) { channel, uid, elapsed in
            //
            //            }
            //
            //            if result == 0 {
            //                base.showMessage(title: "Success", text: "Successfully joined the channel as \(base.userRole)")
            //            }
        }
    }
}
