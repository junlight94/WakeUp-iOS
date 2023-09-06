//
//  AudioButton+General.swift
//  DSKit
//
//  Created by 강현준 on 2023/09/05.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public class AudioButton_General: UIButton {
    let onImage: UIImage?
    let offImage: UIImage?
    
    public var isOn: Bool = true {
        didSet {
            if isOn {
                self.setImage(onImage, for: .normal)
            } else {
                self.setImage(offImage, for: .normal)
            }
        }
    }
    
    public init() {
        self.onImage = .image(dsimage: .micRounded)
        self.offImage = .image(dsimage: .micOffRounded)
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.setImage(onImage, for: .normal)
        self.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
    }
    
    @objc func handleButtonClick() {
        isOn.toggle()
    }
}
