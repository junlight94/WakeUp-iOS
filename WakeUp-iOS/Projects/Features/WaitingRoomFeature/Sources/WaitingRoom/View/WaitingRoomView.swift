//
//  WaitingRoomView.swift
//  WaitingRoomFeature
//
//  Created by 강현준 on 2023/08/29.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import DSKit


import BaseFeatureDependency

final class WaitingRoomMainView: BaseFlexScrollableView {
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "아침 기상 모임", typo: .bold, size: 24)
        $0.textColor = .mainLabelColor
    }
    
    let mainImageView = UIImageView().then {
        $0.image = .image(dsimage: .DummyImage)
        $0.contentMode = .scaleToFill
    }
    
    
    let starttimeLabel = UILabel().then {
        $0.setLabel(text: "8시 30분 시작 예정", typo: .bold, size: 20)
    }
    
    let participantsLabel = UILabel().then {
        $0.setLabel(text: "현재 {{N}}명 참여중이에요", typo: .regular, size: 16)
        $0.textColor = .waitingRoom.parcitipantsColor
    }
    
    let cameraButton = UIButton().then {
        $0.setButton(image: .videocamRounded)
    }
    
    let infoBackgroundView = UIView().then {
        $0.backgroundColor = .waitingRoom.infoBackgroundColor
        $0.layer.cornerRadius = 16
    }
    
    let micButton = UIButton().then {
        $0.setButton(image: .micRounded)
    }
    
    let joinButton = Button_General().then {
        $0.setTitle("참여하기", for: .normal)
    }
    
    override func layout() {
        super.layout()
        
        contentView.flex.direction(.column)
            .justifyContent(.spaceBetween)
            .define { flex in
                
            flex.addItem().direction(.column).define { flex in
                flex.addItem(titleLabel).marginLeft(16).marginBottom(12)
                
                flex.addItem(mainImageView).height(328)
                
                flex.addItem(infoBackgroundView)
                    .marginTop(24).marginLeft(16).marginRight(16)
                    .direction(.column).alignItems(.center)
                    .define { flex in
                        
                        flex.addItem().backgroundColor(.clear).margin(16, 16, 16, 16).alignItems(.center).define { flex in
                            flex.addItem(starttimeLabel)
                            flex.addItem(participantsLabel)
                        }
                        
                        flex.addItem().backgroundColor(.clear).margin(16, 16, 16, 16).direction(.row).alignItems(.center).define { flex in
                            flex.addItem(cameraButton).marginLeft(16)
                            flex.addItem(micButton)
                        }
                    }
            }
            
            flex.addItem().direction(.column).define { flex in
                flex.addItem(joinButton).marginBottom(24).marginHorizontal(16).height(50)
            }
        }
    }
}
