//
//  Color+Extension.swift
//  DSKit
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    static let buttonDisableColor = UIColor(r: 0, g: 0, b: 0, a: 0.12)
    static let buttonDisableLabelColor = UIColor(r: 0, g: 0, b: 0, a: 0.12)
    static let buttonEnableColor = UIColor(r: 0, g: 0, b: 0, a: 1)
    static let textFieldBoarderColor = UIColor(r: 0, g: 0, b: 0, a: 0.18)
    static let mainLabelColor = UIColor(r: 0, g: 0, b: 0, a: 0.87)
    static let subLabelColor = UIColor(r: 0, g: 0, b: 0, a: 0.6)
    static let grayColor = UIColor(r: 244, g: 244, b: 244, a: 1)
    static let greenColor = UIColor(r: 71, g: 204, b: 71, a: 1)
    static let whiteColor = UIColor(r: 255, g: 255, b: 255, a: 1)
}
