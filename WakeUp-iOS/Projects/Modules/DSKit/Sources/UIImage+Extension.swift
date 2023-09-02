//
//  UIImage+Extension.swift
//  DSKit
//
//  Created by Junyoung on 2023/08/28.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public enum DSKitImage {
    case DummyImage
    case checkBoxOutlineBlankRounded
    case videocamRounded
    case videocamOffRounded
    case micRounded
    case micOffRounded
    case checkBoxRounded
    
    var toName: String {
        switch self {
            
        case .DummyImage:
            return "DummyImage"
        case .checkBoxOutlineBlankRounded:
            return "CheckBoxOutlineBlankRounded"
        case .videocamRounded:
            return "VideocamRounded"
        case .videocamOffRounded:
            return "VideocamOffRounded"
        case .micRounded:
            return "MicRounded"
        case .micOffRounded:
            return "MicOffRounded"
        case .checkBoxRounded:
            return "CheckBoxRounded"
        }
    }
}

public extension UIImage {
    static func image(dsimage: DSKitImage) -> UIImage? {
        guard let image = UIImage(named: dsimage.toName, in: Bundle.module, compatibleWith: nil) else {
            print("Failed to load : \(dsimage.toName)")
            return nil
        }
        
        return image
    }
    
}
