//
//  JoinVideoCallUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/09/11.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift
import Foundation
import Data

public struct JoinVideoCallUseCase {
    private let agaraRepository: AgoraRepository
    
    func joinChannel() -> Single<Bool> {
        return agaraRepository.joinChannel()
    }
}
