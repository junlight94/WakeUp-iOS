//
//  AgoraRtcServiceProtocol.swift
//  Data
//
//  Created by 강현준 on 2023/09/11.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation
import AgoraRtcKit
import RxSwift

public protocol AgoraRtcServiceProtocol {
    
    var agoraKit: AgoraRtcEngineKit { get set }
    
    func setup(
        appID: String,
        channelID: String,
        token: String,
        uid: UInt,
        clientRole: AgoraClientRole
    )
    func joinChannel() -> Observable<Bool>
    func leaveChannel() -> Observable<Void>
}
