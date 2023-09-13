//
//  AgoraRtcService.swift
//  Data
//
//  Created by 강현준 on 2023/09/06.
//  Copyright © 2023 WakeUp. All rights reserved.
//


import AgoraRtcKit
import RxSwift
import Domain

public enum AgoraRtcError: Error {
    case joinChannel
}

public class AgoraRtcService: AgoraRtcServiceProtocol {
    
    public static let shared = AgoraRtcService()
    
    private var appID: String!
    private var channeldID: String!
    private var token: String!
    private var uid: UInt!
    private var role: AgoraClientRole!
    
    public var agoraKit: AgoraRtcEngineKit
    
    private init() {
        self.agoraKit = AgoraRtcEngineKit()
    }
    
    /// configure method
    public func setup(
        appID: String,
        channelID: String,
        token: String,
        uid: UInt,
        clientRole: AgoraClientRole
    ) {
        self.appID = appID
        self.channeldID = channelID
        self.token = token
        self.uid = uid
        self.role = clientRole
        
        let config = AgoraRtcEngineConfig()
        config.appId = appID
        
        agoraKit = .sharedEngine(withAppId: appID, delegate: nil)
        agoraKit.enableAudioVolumeIndication(500, smooth: 3, reportVad: true)
        
        agoraKit.enableVideo()
        agoraKit.startPreview()
    }
    
    // TODO: - 이상한 channelId랑 token 넣어도 result가 0으로 나옴..
    
    public func joinChannel() -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            
            let option = AgoraRtcChannelMediaOptions()
            option.clientRoleType = self.role
            
            let result = agoraKit.joinChannel(byToken: token, channelId: channeldID, uid: uid, mediaOptions: option, joinSuccess: nil)
            
            print("DEBUG: \(#function) result is \(result)")
        
            if result == 0 {
                emitter.onNext(true)
                emitter.onCompleted()
            } else {
                emitter.onError(AgoraRtcError.joinChannel)
            }
            
            return Disposables.create()
        }
    }
    
    public func leaveChannel() -> Observable<Void> {
        return Observable<Void>.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            
            self.agoraKit.leaveChannel()
            emitter.onNext(())
            emitter.onCompleted()
            return Disposables.create()
        }
    }
}

extension AgoraRtcService: AgoraUIServiceInterface {
    public func createCanvas(uid: UInt) -> AgoraRtcVideoCanvas {
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.renderMode = .hidden
        
        return canvas
    }
    
    public func setupVideo(_ canvas: AgoraRtcVideoCanvas, isLocal: Bool) {
        if isLocal {
            agoraKit.setupLocalVideo(canvas)
        } else {
            agoraKit.setupRemoteVideo(canvas)
        }
    }
    
    public func setupEnableLocalVideo(_ status: Bool) {
        agoraKit.enableLocalVideo(status)
    }
    
    public func setupEnableLocalAudio(_ status: Bool) {
        agoraKit.enableLocalAudio(status)
    }
}


