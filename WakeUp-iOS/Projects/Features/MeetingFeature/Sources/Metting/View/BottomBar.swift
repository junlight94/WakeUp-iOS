//
//  BottomBar.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/09/05.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import DSKit
import BaseFeatureDependency
import FlexLayout

final class BottomBar: BaseFlexView {
    let exitButton = Button_General().then {
        $0.setButton(text: "나가기", typo: .medium, size: 14)
    }
    
    let videoButton = VideoButton_General()
    
    let audioButton = AudioButton_General()
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        rootFlexContainer.flex.direction(.row).justifyContent(.spaceBetween).alignItems(.center).define { flex in
            
            flex.addItem(exitButton).marginLeft(24).width(63).height(29)
            
            
            flex.addItem().direction(.row).marginRight(24).define { flex in
                flex.addItem(videoButton).width(52).height(52)
                flex.addItem(audioButton).width(52).height(52)
            }
        }
    }
    
    func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
    }
}
