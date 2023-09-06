//
//  Rtc.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/09/04.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import BaseFeatureDependency
import Foundation
import AgoraRtcKit
import RxSwift

class Rtc: NSObject {
    
    var agoraKit: AgoraRtcEngineKit!
    
    let appID: String
    let channelId: String
    let token: String
    let uid: UInt
    
    init(
        appID: String,
        channelId: String,
        token: String,
        uid: UInt
    ) {
        self.appID = appID
        self.channelId = channelId
        self.token = token
        self.uid = uid
        
        super.init()

//        let config = AgoraRtcEngineConfig()
//        config.appId = appID
//        agoraKit = .sharedEngine(withAppId: appID, delegate: nil)
//        agoraKit.enableAudioVolumeIndication(300, smooth: 5, reportVad: true)
//        
//        agoraKit.enableVideo()
//        agoraKit.startPreview()
    }
    
    func joinChannel() -> Observable<Bool> {
        
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            
            let option = AgoraRtcChannelMediaOptions()

            option.clientRoleType = .broadcaster
            
            let result = agoraKit.joinChannel(byToken: token, channelId: channelId, uid: uid, mediaOptions: option) { msg, uid, elapsed in
                return
            }
            
            print("DEBUG: Result = \(result)")
            
            if result == 0 {
                emitter.onNext(true)
            } else {
                emitter.onNext(false)
            }
            
            emitter.onCompleted()
            return Disposables.create()
        }
    }
    
    func createCanvas(uid: UInt) -> AgoraRtcVideoCanvas {
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.renderMode = .hidden
        
        return canvas
    }
}

