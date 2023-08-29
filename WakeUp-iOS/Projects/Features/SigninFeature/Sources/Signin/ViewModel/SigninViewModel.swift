//
//  SigninViewModel.swift
//  SigninFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import RxSwift

import BaseFeatureDependency

final class SigninViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: SigninCoordinator?
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
