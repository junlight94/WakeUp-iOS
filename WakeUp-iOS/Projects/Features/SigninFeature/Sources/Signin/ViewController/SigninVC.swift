//
//  SigninVC.swift
//  SigninFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import BaseFeatureDependency

class SigninVC: BaseVC, ViewModelBindable {

    private let mainView = SigninMainView()
    
    var viewModel: SigninViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    func bindViewModel() {
        
    }

}
