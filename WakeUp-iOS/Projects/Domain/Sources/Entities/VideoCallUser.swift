//
//  VideoCallUser.swift
//  Domain
//
//  Created by 강현준 on 2023/09/12.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation

public struct VideoCallUser {
    public let uid: UInt
    public let displayName: String
    public var isAudioMuted: Bool
    public var isVideoMuted: Bool
    public var isSpeaking: Bool
    
    public init(uid: UInt) {
        self.uid = uid
        self.displayName = "User"
        self.isAudioMuted = false
        self.isVideoMuted = false
        self.isSpeaking = false
    }
    
    init(uid: UInt, displayName: String, isAudioMuted: Bool, isVideoMuted: Bool, isSpeaking: Bool) {
        self.uid = uid
        self.displayName = displayName
        self.isAudioMuted = isAudioMuted
        self.isVideoMuted = isVideoMuted
        self.isSpeaking = isSpeaking
    }
}
