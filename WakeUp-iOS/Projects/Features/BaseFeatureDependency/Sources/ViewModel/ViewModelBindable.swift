//
//  ViewModelBindable.swift
//  BaseFeatureDependency
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewModelBindable where Self: UIViewController {
    associatedtype ViewModelType
    var viewModel: ViewModelType { get set }
    func bindViewModel()
}

public extension ViewModelBindable {
    func bind(to viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
