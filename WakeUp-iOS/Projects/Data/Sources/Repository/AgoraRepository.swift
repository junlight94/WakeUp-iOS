//
//  AgoraRtcRepository.swift
//  Data
//
//  Created by 강현준 on 2023/09/11.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift
import Foundation

public class AgoraRepository: NSObject {
    private let agoraService: AgoraRtcService
    
    public func joinChannel() -> Single<Bool> {
        return agoraService.joinChannel()
    }
    
    init(agoraService: AgoraRtcService) {
        self.agoraService = agoraService
        super.init()
    }
}
