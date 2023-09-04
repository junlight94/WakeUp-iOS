//
//  GroupVideoCallContainerView.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/09/01.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout
import DSKit

import BaseFeatureDependency

enum UserClass {
    case local
    case remote
}

final class GroupVideoContainerView: BaseFlexView {
    
    private let videoContainer = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.setLabel(text: "name", typo: .medium, size: 18)
        $0.textColor = .white
    }
    
    private let offMicImageView = UIImageView().then {
        $0.image = .image(dsimage: .cellMicOffRounded)
        
    }
    
    private let offCamImageView = UIImageView().then {
        $0.image = .image(dsimage: .cellCamOffRounded)
    }
    
    private let isTalkingBorderView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.meetingColor.backgrounColor.cgColor
        $0.layer.cornerRadius = 16
    }
    
    var videoLayer: UIView {
        return videoContainer
    }
    
    init(userClass: UserClass = .remote) {
        super.init(frame: .zero)
        
        if userClass == .local {
            [ offMicImageView, offCamImageView ].forEach { $0.isHidden = false }
            nameLabel.text = "나"
        }
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(videoContainer).height(100%).width(100%).justifyContent(.spaceBetween).define { flex in
                
                flex.addItem(isTalkingBorderView).height(100%).width(100%).define { flex in
                    
                    flex.addItem().direction(.column).position(.absolute).left(16).top(16).define { flex in
                        flex.addItem(nameLabel)
                    }
                    
                    flex.addItem().direction(.row).position(.absolute).left(16).bottom(16).define { flex in
                        flex.addItem(offMicImageView)
                        flex.addItem(offCamImageView).marginLeft(16)
                    }
                    
                }
                
                
            }
        }
    }
}
