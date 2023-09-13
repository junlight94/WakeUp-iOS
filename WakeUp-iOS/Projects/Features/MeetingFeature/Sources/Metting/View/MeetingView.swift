//
//  MeetingView.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/08/30.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import BaseFeatureDependency
import Core
import Then
import FlexLayout
import PinLayout
import DSKit

import RxCocoa
import RxSwift

final class MeetingMainView: BaseFlexScrollableView {
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "아침 기상 모임", typo: .bold, size: 24)
        $0.textColor = .mainLabelColor
    }
    
    internal let joinUserCountLabel = UILabel().then {
        $0.setLabel(text: "{{N}}명 참여중", typo: .regular, size: 16)
        $0.textColor = .meetingColor.parcitipantsColor
    }
    
    let myVideoContainer = GroupVideoContainerView(userClass: .local).then {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .meetingColor.cameraOffBackgroundColor
        }
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        let screenWidth = UIScreen.main.bounds.width
        let size = screenWidth / 2
        
        $0.itemSize = CGSize(width: size, height: size)
        $0.minimumInteritemSpacing = 16
        $0.minimumLineSpacing = 16
        $0.scrollDirection = .vertical
    }

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).then {
        $0.register(MeetingCollectionViewCell.self, forCellWithReuseIdentifier: MeetingCollectionViewCell.identifier)
        $0.backgroundColor = .clear
    }
    
    let bottomBar = BottomBar()
        
    func setDelegate<T: UIViewController>(_ viewController: T) where T: UICollectionViewDelegateFlowLayout {
        self.collectionView.delegate = viewController
    }
    
    override func layout() {
        super.layout()
        
        contentView.flex.direction(.column).define { flex in
            
            flex.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.start).define { flex in
                flex.addItem(titleLabel).marginLeft(16).marginBottom(12)
                flex.addItem(joinUserCountLabel).marginRight(16).marginTop(6)
            }
            
            flex.addItem().direction(.column).backgroundColor(.meetingColor.backgrounColor).define { flex in
                
                let itemSize = UIScreen.main.bounds.width - 32
                
                flex.addItem(myVideoContainer).margin(16).height(itemSize).width(itemSize)
                flex.addItem(collectionView).margin(16).height(itemSize).width(itemSize)
                
                flex.addItem().height(68).backgroundColor(.clear)
            }
        }
        
        rootFlexContainer.flex.direction(.column).justifyContent(.spaceBetween).define { flex in
            flex.addItem(bottomBar).marginBottom(0).height(100).width(100%)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        scrollView.pin.all()
        contentView.pin.all()
        
        contentView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
}

extension Reactive where Base: MeetingMainView {
    var joinUserCount: Binder<Int> {
        return Binder(base) { view, count in
            view.joinUserCountLabel.text = "\(count)명 참여중"
        }
    }
}

