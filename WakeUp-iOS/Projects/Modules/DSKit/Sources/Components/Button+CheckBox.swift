//
//  Button+CheckBox.swift
//  DSKit
//
//  Created by Junyoung on 2023/09/02.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public class Button_CheckBox: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setImage(.image(dsimage: .checkBoxRounded), for: .normal)
            } else {
                self.setImage(.image(dsimage: .checkBoxOutlineBlankRounded), for: .normal)
            }
        }
    }
    
    private func setup() {
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        self.setImage(.image(dsimage: .checkBoxOutlineBlankRounded), for: .normal)
        self.setButton(text: "모임 시작 10분 전에 알림 받기", typo: .regular, size: 16)
        self.setTitleColor(.mainLabelColor, for: .normal)
        
    }
}

