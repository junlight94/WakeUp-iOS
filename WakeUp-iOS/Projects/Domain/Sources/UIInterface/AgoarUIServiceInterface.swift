//
//  AgoarUIServiceInterface.swift
//  Domain
//
//  Created by 강현준 on 2023/09/13.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import AgoraRtcKit

public protocol AgoraUIServiceInterface {
    func createCanvas(uid: UInt) -> AgoraRtcVideoCanvas
    func setupVideo(_ canvas: AgoraRtcVideoCanvas, isLocal: Bool)
    func setupEnableLocalVideo(_ status: Bool)
    func setupEnableLocalAudio(_ status: Bool)
}
