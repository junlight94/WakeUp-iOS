//
//  BaseFlexView.swift
//  BaseFeatureDependency
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import FlexLayout
import PinLayout
import UIKit

open class BaseFlexView: UIView {
    public let rootFlexContainer = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func layout() {
        rootFlexContainer.flex.define { flex in
            
        }
        addSubview(rootFlexContainer)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}
