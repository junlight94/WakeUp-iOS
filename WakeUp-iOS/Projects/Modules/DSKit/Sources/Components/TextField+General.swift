//
//  TextField+General.swift
//  DSKit
//
//  Created by Junyoung on 2023/08/28.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

open class TextField_General: UITextField {
    
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
        
        self.textColor = .mainLabelColor
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textFieldBoarderColor.cgColor
        self.font = .setFont(font: .regular, size: 16)
        
    }
}
