//
//  SigninMainView.swift
//  SigninFeature
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BaseFeatureDependency

class SigninMainView: BaseFlexView {

    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    let view4 = UIView()
    let view5 = UIView()
    
    override func layout() {
        super.layout()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(view1).height(100).backgroundColor(.black)
            flex.addItem(view2).height(100).backgroundColor(.blue)
            flex.addItem(view3).height(100).backgroundColor(.yellow)
            flex.addItem(view4).height(100).backgroundColor(.gray)
            flex.addItem(view5).height(100).backgroundColor(.green)
        }
    }
    
}
