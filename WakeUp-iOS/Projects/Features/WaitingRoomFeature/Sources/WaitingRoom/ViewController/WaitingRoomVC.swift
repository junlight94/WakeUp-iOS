//
//  WaitingRoomVC.swift
//  WaitingRoomFeature
//
//  Created by 강현준 on 2023/08/29.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import BaseFeatureDependency

final class WaitingRoomVC: BaseVC, ViewModelBindable {
    
    private let waitingRoomView = WaitingRoomMainView()
    
    var viewModel: WaitingRoomViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        self.view = waitingRoomView
    }
    
    func bindViewModel() {
        
    }
}
