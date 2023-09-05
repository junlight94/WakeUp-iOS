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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        groupCallContainer.pin.all()
    }
}
