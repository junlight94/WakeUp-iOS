//
//  WaitingRoomViewModel.swift
//  WaitingRoomFeature
//
//  Created by 강현준 on 2023/08/29.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import BaseFeatureDependency
import RxSwift

final class WaitingRoomViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: WaitingRoomCoordinator?
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
