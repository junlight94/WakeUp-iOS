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
], baseSettings: Settings.settings(
    configurations: XCConfig.framework
))

let carthage = CarthageDependencies([
    .github(path: "layoutBox/FlexLayout",
            requirement: .branch("master")),
    .github(path: "layoutBox/PinLayout",
            requirement: .branch("master")),
])

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: spm,
    platforms: [.iOS]
)
