//
//  SigninVC.swift
//  SigninFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import Core
import BaseFeatureDependency

class SigninVC: BaseVC, ViewModelBindable {

    private let mainView = SigninMainView()
    
    var viewModel: SigninViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let tapAlarm = mainView.checkButton.rx.tap
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                return mainView.checkButton.isSelected
            }
            .asObservable()
        
        let input = SigninViewModel.Input(tapAlarm: tapAlarm)
        
        let output = viewModel.transform(input: input)
        
        output.alarmState
            .drive(onNext: { [weak self] state in
                self?.mainView.checkButton.isSelected = state
            })
            .disposed(by: disposeBag)
    }
}
