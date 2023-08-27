//
//  DefaultSigninCoordinator.swift
//  SigninFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public final class DefaultSigninCoordinator: SigninCoordinator {
    
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public var coordinatorType: CoordinatorType { .signin }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let signinVC = SigninVC()
        let viewModel = SigninViewModel()
        
        signinVC.bind(to: viewModel)
        viewModel.coordinator = self
        
        self.navigationController.pushViewController(signinVC, animated: true)
    }
    
    
}
