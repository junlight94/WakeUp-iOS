//
//  CustomView.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/09/01.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation
import PinLayout
import FlexLayout

class CustomView: UIView {
    
    let childView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func layout() {
        
    }
}
