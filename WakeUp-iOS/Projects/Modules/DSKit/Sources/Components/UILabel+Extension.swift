//
//  UILabel+Extension.swift
//  DSKitTests
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public extension UILabel {
    @discardableResult
    func setLabel(text: String, typo: SansNeo, size: CGFloat) -> Self {
        self.text = text
        self.font = .setFont(font: typo, size: size)
        return self
    }
}
