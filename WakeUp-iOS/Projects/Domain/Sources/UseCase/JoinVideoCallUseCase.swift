//
//  JoinVideoCallUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/09/11.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift
import Foundation

public protocol JoinVideoCallUseCaseProtocol {
    func joinChannel() -> Observable<Bool>
}

public struct JoinVideoCallUseCase: JoinVideoCallUseCaseProtocol {
    
    private let agoraRepository: AgoraRepositoryProtocol
    
    public init(agoraRepository: AgoraRepositoryProtocol) {
        self.agoraRepository = agoraRepository
    }
    
    public func joinChannel() -> Observable<Bool> {
        return agoraRepository.joinChannel()
    }
}
