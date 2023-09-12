//
//  GroupVideoCallContainerView.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/09/01.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout
import DSKit

import BaseFeatureDependency
import MetalKit

import RxSwift
import RxCocoa

import Domain

enum UserClass {
    case local
    case remote
}

final class GroupVideoContainerView: BaseFlexView {
    
    private let videoContainer = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    let nameLabel = UILabel().then {
        $0.setLabel(text: "name", typo: .medium, size: 18)
        $0.textColor = .white
    }
    
    private let offMicImageView = UIImageView().then {
        $0.image = .image(dsimage: .cellMicOffRounded)
        
    }
    
    private let offCamImageView = UIImageView().then {
        $0.image = .image(dsimage: .cellCamOffRounded)
    }
    
    private let isTalkingBorderView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.meetingColor.backgrounColor.cgColor
        $0.layer.cornerRadius = 16
    }
    
    /// Agora로 인해 최상단에 생겨서 컴포넌트를 가리는 뷰
    private var mtkView: UIView?
    
    var videoLayer: UIView {
        return videoContainer
    }
    
    init(userClass: UserClass = .remote) {
        super.init(frame: .zero)
        
        if userClass == .local {
            [ offMicImageView, offCamImageView ].forEach { $0.isHidden = false }
        }
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: VideoCallUser) {
        self.nameLabel.text = user.displayName
        self.offMicImageView.isHidden = !user.isAudioMuted
        self.offCamImageView.isHidden = !user.isVideoMuted
        
        if let mtkView = mtkView {
            mtkView.layer.borderColor = user.isSpeaking ? UIColor.meetingColor.talkingBorderColor.cgColor : UIColor.meetingColor.backgrounColor.cgColor
        }
    }
    
    override func layout() {
        super.layout()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(videoContainer).height(100%).width(100%).justifyContent(.spaceBetween).define { flex in

                flex.addItem().direction(.column).position(.absolute).left(16).top(16).define { flex in
                    flex.addItem(nameLabel)
                }
                
                flex.addItem().direction(.row).position(.absolute).left(16).bottom(16).define { flex in
                    flex.addItem(offMicImageView)
                    flex.addItem(offCamImageView).marginLeft(16)
                }
            }
        }
    }
    
    func bringComponentoToFront() {
        
        guard let mtkView = findView(in: rootFlexContainer, matching: { $0 is MTKView }) else { return }
        
        self.mtkView = mtkView.then {
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor.meetingColor.backgrounColor.cgColor
            $0.layer.borderWidth = 4
            $0.layer.shadowOpacity = 0
            $0.clipsToBounds = true
        }
        
        addSubview(mtkView)
        
        mtkView.flex.direction(.column).justifyContent(.spaceBetween).define{ flex in
        
            flex.addItem().direction(.column).position(.absolute).left(16).top(16).define { flex in
                flex.addItem(nameLabel)
            }
            
            flex.addItem().direction(.row).position(.absolute).left(16).bottom(16).define { flex in
                flex.addItem(offMicImageView)
                flex.addItem(offCamImageView).marginLeft(16)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mtkView?.pin.all()
        mtkView?.flex.layout()
    }
    
    /// 중첩된 뷰 구조에서 원하는 뷰를 찾음
    func findView(in parentView: UIView, matching criteria: (UIView) -> Bool) -> UIView? {
        for subview in parentView.subviews {
            if criteria(subview) {
                return subview
            }
            if let found = findView(in: subview, matching: criteria) {
                return found
            }
        }
        return nil
    }
}

extension Reactive where Base: GroupVideoContainerView {
    var videoCallUser: Binder<VideoCallUser> {
        return Binder(base) { view, user in
            view.configure(user: user)
        }
    }
}
