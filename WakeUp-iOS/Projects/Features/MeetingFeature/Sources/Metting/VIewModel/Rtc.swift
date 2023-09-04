//
//  Rtc.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/08/31.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AgoraRtcKit

class Rtc: NSObject {
    var agoraKit: AgoraRtcEngineKit!
    
    func leave() -> Single<Void> {
        agoraKit.setupLocalVideo(nil)
        agoraKit.leaveChannel(nil)
        agoraKit.stopPreview()
        AgoraRtcEngineKit.destroy()
        return .just(())
    }
    
    init(appID: String, channelID: String, token: String) {
        
    }
}
