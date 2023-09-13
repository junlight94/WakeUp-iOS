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

import Domain


final class MeetingVC: BaseVC, ViewModelBindable {
    
    private let baseflexContainer = BaseFlexScrollableView()
    private let mainView = MeetingMainView()
    
    private let agoraUIService: AgoraUIServiceInterface
    
    var viewModel: MeetingViewModel?
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.setDelegate(self)
    }
    
    init(agoraUIService: AgoraUIServiceInterface) {
        self.agoraUIService = agoraUIService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func apply(canvas: AgoraRtcVideoCanvas, toView view: UIView?, isLocal: Bool) {
        if canvas.view == view { return }
        
        canvas.view = view
        
        agoraUIService.setupVideo(canvas, isLocal: isLocal)
    }
    
    func bindViewModel() {
        let input = MeetingViewModel.Input(
            viewDidLoad: rx.viewWillAppar.take(1).map { _ in () },
            localUserAudioTapped: mainView.bottomBar.audioButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            localUserVideoTapped: mainView.bottomBar.videoButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            viewDidDisappear: rx.viewDidDisApplear.map { _ in () }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            leaveButtonTapped: mainView.bottomBar.leaveButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        guard let output = viewModel?.transform(input: input) else { return }
        
        bindLocalUser(input: output)
        bindAlert(input: output)
        bindPermission(input: output)
        bindRemoteuser(input: output)
        bindAttribute(input: output)
    }
    
    func bindAlert(input: MeetingViewModel.Output) {
        
        input.alert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    func bindPermission(input: MeetingViewModel.Output) {
        
        input.checkUserPermission
            .emit(to: rx.requestCameraAndMicPermission)
            .disposed(by: disposeBag)
    }
    
    func bindLocalUser(input: MeetingViewModel.Output) {
        
        input.setupLocalVideo
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let canvas = agoraUIService.createCanvas(uid: 0)
                self.apply(canvas: canvas, toView: self.mainView.myVideoContainer.videoLayer, isLocal: true)
            })
            .disposed(by: disposeBag)
        
        
        input.localUser
            .do(onNext: { print("DEBUG: localUserBind \($0)") })
            .drive(mainView.myVideoContainer.rx.videoCallUser)
            .disposed(by: disposeBag)
        
        input.localUser
            .drive(mainView.bottomBar.rx.bottomBar)
            .disposed(by: disposeBag)
    }
    
    func bindRemoteuser(input: MeetingViewModel.Output) {
        input.remoteUsers
            .drive(mainView.collectionView.rx.items) { [weak self] collectionView, index, user in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MeetingCollectionViewCell.identifier,
                        for: IndexPath(row: index, section: 0)
                      ) as? MeetingCollectionViewCell else { return UICollectionViewCell() }
                
                let remoteID = user.uid
                
                let videoCanvas = agoraUIService.createCanvas(uid: remoteID)
                self.apply(canvas: videoCanvas, toView: cell.videoContainer.videoLayer, isLocal: false)
                cell.configure(user)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func bindAttribute(input: MeetingViewModel.Output) {
        input.joinUserCount
            .drive(mainView.rx.joinUserCount)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.myVideoContainer.bringComponentoToFront()
    }
}

extension MeetingVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = view.frame.size.width
        let itemSize = (screenWidth - 16 - 16 - 16) / 2
        
        return CGSize(width: itemSize, height: itemSize)
    }
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
}
