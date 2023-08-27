//
//  ViewModelType.swift
//  BaseFeatureDependency
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
        
    func transform(input: Input) -> Output
}
