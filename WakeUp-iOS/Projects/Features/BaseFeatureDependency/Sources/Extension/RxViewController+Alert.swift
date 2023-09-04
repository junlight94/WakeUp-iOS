//
//  RxViewController+Alert.swift
//  BaseFeatureDependency
//
//  Created by 강현준 on 2023/09/03.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct Alert {
    let title: String
    let message: String
    let delayTime: Int = 3
    let observer: AnyObserver<Bool>?
    
    
    public init (title: String, message: String) {
        self.title = title
        self.message = message
        self.observer = nil
    }
}

public extension Reactive where Base: UIViewController {
    var presentNotification: Binder<Alert> {
        return Binder(base) { base, alert in
            
            let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
            base.present(alertController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(alert.delayTime), execute: {
                alertController.dismiss(animated: true)
            })
        }
    }
    
    var presentAlert: Binder<Alert> {
        return Binder(base) { base, alert in
            let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                alert.observer?.onNext(true)
                alert.observer?.onCompleted()
            })
            alertController.addAction(okAction)
            base.present(alertController, animated: true)
        }
    }
}


