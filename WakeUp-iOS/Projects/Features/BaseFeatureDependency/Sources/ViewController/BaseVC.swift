//
//  BaseVC.swift
//  BaseFeatureDependency
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import Core

open class BaseVC: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
}
