//
//  AgoraRtcService.swift
//  Data
//
//  Created by 강현준 on 2023/09/06.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation
import AgoraRtcKit
import RxSwift

public enum AgoraRtcError: Error {
    case joinChannel
}

public class AgoraRtcService: NSObject {
    
    public static let shared = AgoraRtcService()
    
    private var appID: String!
    private var channeldID: String!
    private var token: String!
    private var uid: UInt!
    private var role: AgoraClientRole!
    
    var agoraKit: AgoraRtcEngineKit?
    
    private override init() { super.init() }
    
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
        agoraKit?.enableAudioVolumeIndication(300, smooth: 3, reportVad: true)
        
        agoraKit?.enableVideo()
        agoraKit?.startPreview()
    }
    
    public func joinChannel() -> Single<Bool> {
        return Single<Bool>.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            let option = AgoraRtcChannelMediaOptions()
            option.clientRoleType = self.role
            
            let result = agoraKit?.joinChannel(byToken: token, channelId: channeldID, uid: uid, mediaOptions: option, joinSuccess: nil)
            
            print("DEBUG: \(#function) result is \(result)")
        
            if result == 0 {
                single(.success(true))
            } else {
                single(.failure(AgoraRtcError.joinChannel))
            }
            
            return Disposables.create()
        }
    }
    
    public func createCanvas(uid: UInt) -> AgoraRtcVideoCanvas {
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.renderMode = .hidden
        
        return canvas
    }
    
    public func leaveChannel() {
        agoraKit?.leaveChannel(nil)
    }
    
    public func printddd() {
        print("212312312312312312312312323")
    }
}
