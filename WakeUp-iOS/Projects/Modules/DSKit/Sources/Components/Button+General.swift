//
//  Button+General.swift
//  DSKit
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public class Button_General: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .buttonEnableColor
                self.setTitleColor(.whiteColor, for: .normal)
            } else {
                self.backgroundColor = .buttonDisableColor
                self.setTitleColor(.buttonDisableLabelColor, for: .normal)
            }
        }
    }
    
    private func setup() {
        self.layer.cornerRadius = 4
        self.setButton(text: "", typo: .bold, size: 18)
        self.backgroundColor = .buttonEnableColor
        self.setTitleColor(.whiteColor, for: .normal)
        
    }
}
