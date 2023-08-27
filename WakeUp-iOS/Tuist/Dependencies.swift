//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 2023/08/23.
//

import ProjectDescription
import ConfigPlugin
import EnvPlugin

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.6.0")),
    .remote(url: "https://github.com/Moya/Moya.git", requirement: .exact("15.0.0")),
    .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .exact("2.8.3")),
    .remote(url: "https://github.com/devxoul/Then.git", requirement: .exact("3.0.0")),
], baseSettings: Settings.settings(
    configurations: XCConfig.framework
))

let carthage = CarthageDependencies([
    .github(path: "layoutBox/FlexLayout", requirement: .exact("1.3.33")),
    .github(path: "layoutBox/PinLayout", requirement: .exact("1.10.4")),
])

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: spm,
    platforms: [.iOS]
)
