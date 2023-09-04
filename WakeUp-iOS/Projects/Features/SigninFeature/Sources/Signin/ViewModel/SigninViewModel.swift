//
//  SigninViewModel.swift
//  SigninFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift
import RxCocoa

import BaseFeatureDependency

final class SigninViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: SigninCoordinator?
    
    struct Input {
        let tapAlarm: Observable<Bool>
    }
    
    struct Output {
        let alarmState: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let alarmState = input.tapAlarm
            .map { isSelected in
                return isSelected ? false : true
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(alarmState: alarmState)
    }
}
