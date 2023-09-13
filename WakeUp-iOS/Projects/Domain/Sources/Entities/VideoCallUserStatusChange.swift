//
//  VideoCallUserStatusChange.swift
//  Domain
//
//  Created by 강현준 on 2023/09/13.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation

public struct VideoCallUserStatusChange {
    public let uid: UInt
    public let status: Bool
    
    public init(uid: UInt, status: Bool) {
        self.uid = uid
        self.status = status
    }
}
