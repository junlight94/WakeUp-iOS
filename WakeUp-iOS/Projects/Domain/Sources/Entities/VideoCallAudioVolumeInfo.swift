//
//  VideoCallAudioVolumeInfo.swift
//  Domain
//
//  Created by 강현준 on 2023/09/13.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation

public struct VideoCallAudioVolumeInfo: Equatable {
    public let uid: UInt
    public let vad: UInt // 0이면 말하지 않는중
    public let volume: UInt
    
    public init(uid: UInt, vad: UInt, volume: UInt) {
        self.uid = uid
        self.vad = vad
        self.volume = volume
    }
}
