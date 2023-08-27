//
//  UIFont+Extension.swift
//  DSKitTests
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//


import UIKit

public enum SansNeo: String {
    case regular
    case light
    case bold
    case medium
    case thin
    
    public var font: String {
        switch self {
        case .regular:
            return "SpoqaHanSansNeo-Regular"
        case .light:
            return "SpoqaHanSansNeo-Light"
        case .bold:
            return "SpoqaHanSansNeo-Bold"
        case .medium:
            return "SpoqaHanSansNeo-Medium"
        case .thin:
            return "SpoqaHanSansNeo-Thin"
        }
    }
}

public extension UIFont {
    static func setFont(font: SansNeo, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: font.font, size: size) else {
            print("폰트 적용 실패")
            return UIFont.systemFont(ofSize: size)
        }
        print("폰트 적용 성공")
        return font
    }
}

