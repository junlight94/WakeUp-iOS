//
//  RxUIViewController+Lifecycle.swift
//  BaseFeatureDependency
//
//  Created by 강현준 on 2023/09/03.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _  in () }
        
        return ControlEvent(events: source)
    }
    
    var viewWillAppar: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { $0.first as? Bool ?? false }
        
        return ControlEvent(events: source)
    }
    
    var viewWillDisAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear(_:))).map { $0.first as? Bool ?? false}
        
        return ControlEvent(events: source)
    }
    
    var viewDidDisApplear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear(_:))).map { $0.first as? Bool ?? false }
        
        return ControlEvent(events: source)
    }
}

