//
//  AgoraRtcAudioVolumeInfo+Ex.swift
//  Data
//
//  Created by 강현준 on 2023/09/13.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import AgoraRtcKit
import Domain

extension AgoraRtcAudioVolumeInfo {
    func toDomain() -> VideoCallAudioVolumeInfo {
        return VideoCallAudioVolumeInfo(
            uid: self.uid,
            vad: self.vad,
            volume: self.volume
        )
    }
}
