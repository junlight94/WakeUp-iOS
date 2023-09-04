//
//  UIImage+Extension.swift
//  Core
//
//  Created by 강현준 on 2023/08/31.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.height
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderedImgae = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderedImgae
    }
}
