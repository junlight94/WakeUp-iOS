//
//  Dependency+Libray.swift
//  MyPlugin
//
//  Created by Junyoung on 2023/08/23.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM {}
    enum Carthage {}
}

public extension TargetDependency.SPM {
    static let Then = TargetDependency.external(name: "Then")
    static let Moya = TargetDependency.external(name: "Moya")
    static let Swinject = TargetDependency.external(name: "Swinject")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let RxRelay = TargetDependency.external(name: "RxRelay")
    static let RxKeyboard = TargetDependency.external(name: "RxKeyboard")
    static let AgoraUIKit = TargetDependency.external(name: "AgoraUIKit")
    static let AgoraRtcKit = TargetDependency.external(name: "RtcBasic")
}

public extension TargetDependency.Carthage {
    static let FlexLayout = TargetDependency.external(name: "FlexLayout")
    static let PinLayout = TargetDependency.external(name: "PinLayout")
}
