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
    .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .exact("5.7.1")),
    .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .exact("2.8.3")),
    .remote(url: "https://github.com/devxoul/Then.git", requirement: .exact("3.0.0")),
    .remote(url: "https://github.com/layoutBox/PinLayout.git", requirement: .exact("1.10.4")),
//    .remote(url: "https://github.com/layoutBox/FlexLayout.git", requirement: .exact("1.3.33"))
], baseSettings: Settings.settings(
    configurations: XCConfig.framework
))

let carthage = CarthageDependencies([
    .git(path: "https://github.com/layoutBox/FlexLayout.git", requirement: .exact("1.3.18"))
])

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: spm,
    platforms: [.iOS]
)
