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
import Then
import DSKit

import BaseFeatureDependency

class SigninMainView: BaseFlexScrollableView {

    let titleLabel = UILabel().then {
        $0.setLabel(text: "아침 기상 모임", typo: .bold, size: 24)
        $0.textColor = .mainLabelColor
    }
    
    let mainImageView = UIImageView().then {
        $0.image = .image(dsimage: .DummyImage)
        $0.contentMode = .scaleToFill
    }
    
    let subscriberLabel = UILabel().then {
        $0.setLabel(text: "신청자 정보", typo: .bold, size: 20)
        $0.textColor = .mainLabelColor
    }
    
    let joinLinkLabel = UILabel().then {
        $0.setLabel(text: "아래 신청하신 정보로 참여 링크를 보내드려요", typo: .regular, size: 16)
        $0.numberOfLines = 0
        $0.textColor = .subLabelColor
    }
    
    let nameTextField = TextField_General().then {
        $0.placeholder = "신청자 이름"
    }
    let emailTextField = TextField_General().then {
        $0.placeholder = "신청자 이메일"
    }
    
    let checkButton = UIButton_CheckBox()
    
    let applyButton = Button_General().then {
        $0.setTitle("신청하기", for: .normal)
    }
    
    override func layout() {
        super.layout()
        
        contentView.flex.justifyContent(.spaceBetween).direction(.column).define { flex in
            flex.addItem().define { flex in
                flex.addItem(titleLabel).marginLeft(16).marginBottom(12)
                
                flex.addItem(mainImageView).height(328)
                
                flex.addItem(subscriberLabel).margin(24, 16, 0, 16)
                flex.addItem(joinLinkLabel).margin(0, 16, 0, 16)
                
                flex.addItem(nameTextField).margin(24, 16, 0, 16).height(56)
                flex.addItem(emailTextField).margin(4, 16, 0, 16).height(56)
                
                flex.addItem(checkButton).margin(8, 16, 0, 16).height(56)
            }
            flex.addItem().define { flex in
                flex.addItem(applyButton).height(50).margin(0, 16, 24, 16)
            }
        }
    }
    
}
