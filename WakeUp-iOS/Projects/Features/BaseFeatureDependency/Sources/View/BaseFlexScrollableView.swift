//
//  BaseFlexScrollableView.swift
//  BaseFeatureDependency
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import FlexLayout
import UIKit

open class BaseFlexScrollableView: UIView {
    let rootFlexContainer = UIView()
    public let scrollView = UIScrollView()
    
    public let contentView = UIView()
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func layout() {
        
        addSubview(rootFlexContainer)
        rootFlexContainer.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
        scrollView.pin.all()
        contentView.pin.all()
        
        contentView.flex.layout(mode: .adjustHeight)
        
        scrollView.contentSize = contentView.frame.size
        
    }

}
