//
//  UIButton+Extension.swift
//  DSKit
//
//  Created by Junyoung on 2023/08/28.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public extension UIButton {
    func setButton(text: String, typo: SansNeo, size: CGFloat) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .setFont(font: typo, size: size)
    }

    func setButton(image: DSKitImage) {
        guard let image = UIImage(named: image.toName, in: Bundle.module, compatibleWith: nil) else { return }
        self.setImage(image, for: .normal)
    }
}
