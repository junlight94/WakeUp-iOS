//
//  MeetingCollectionViewCell.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/08/31.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import BaseFeatureDependency

import UIKit
import Then
import FlexLayout
import PinLayout
import DSKit

import Core


final class MeetingCollectionViewCell: UICollectionViewCell, Identifiable {
    
    let groupCallContainer = GroupVideoContainerView(userClass: .remote)
    
//    let flexContainer = BaseFlexView()
//
//    let videoContainer = UIView().then {
//        $0.backgroundColor = .gray
//        $0.layer.cornerRadius = 16
//    }
//
//    let nameLabel = UILabel().then {
//        $0.setLabel(text: "name", typo: .medium, size: 18)
//        $0.textColor = .white
//    }
//
//    let offMicImageView = UIImageView().then {
//        $0.image = .image(dsimage: .cellMicOffRounded)
//
//    }
//
//    let offCamImageView = UIImageView().then {
//        $0.image = .image(dsimage: .cellCamOffRounded)
//    }
//
//    let isTalkingBorderView = UIView().then {
//        $0.backgroundColor = .clear
//        $0.layer.borderWidth = 4
//        $0.layer.borderColor = UIColor.meetingColor.talkingBorderColor.cgColor
//        $0.layer.cornerRadius = 16
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        
        contentView.addSubview(groupCallContainer)
        
        groupCallContainer.flex.define { flex in
            
        }
        
//        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//
//        let screenSize = window.screen.bounds
//        let videoViewSize = (screenSize.width - 48) / 2
//
//        contentView.addSubview(flexContainer)
//
//        flexContainer.rootFlexContainer.flex.define { flex in
//            flex.addItem(videoContainer).height(videoViewSize).width(videoViewSize).justifyContent(.spaceBetween).define { flex in
//
//                flex.addItem(isTalkingBorderView).height(videoViewSize).width(videoViewSize).justifyContent(.spaceBetween).define { flex in
//
//                    flex.addItem().direction(.column).define { flex in
//                        flex.addItem(nameLabel).marginTop(16).marginLeft(16)
//                    }
//
//                    flex.addItem().direction(.row).marginBottom(0).marginLeft(0).define { flex in
//                        flex.addItem(offMicImageView).marginLeft(16).marginBottom(16)
//                        flex.addItem(offCamImageView).marginLeft(16).marginBottom(16)
//                    }
//
//                }
//
//
//            }
//        }
//
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        groupCallContainer.pin.all()
    }
}
