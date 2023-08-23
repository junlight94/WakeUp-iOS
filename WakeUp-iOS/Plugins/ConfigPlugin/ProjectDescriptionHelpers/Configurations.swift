//
//  Configurations.swift
//  MyPlugin
//
//  Created by Junyoung on 2023/08/23.
//

import ProjectDescription

public struct XCConfig {
    private struct Path {
        static var framework: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Framework.xcconfig") }
        static var demo: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Demo.xcconfig") }
        static var tests: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Tests.xcconfig") }
        static func project(_ config: String) -> ProjectDescription.Path { .relativeToRoot("xcconfigs/Base/Projects/Project-\(config).xcconfig") }
    }
    
    public static let framework: [Configuration] = [
        .debug(name: "DEV", xcconfig: Path.framework),
        .release(name: "PROD", xcconfig: Path.framework),
    ]
    
    public static let tests: [Configuration] = [
        .debug(name: "DEV", xcconfig: Path.tests),
        .release(name: "PROD", xcconfig: Path.tests),
    ]
    
    public static let demo: [Configuration] = [
        .debug(name: "DEV", xcconfig: Path.demo),
        .release(name: "PROD", xcconfig: Path.demo),
    ]
    
    public static let project: [Configuration] = [
        .debug(name: "DEV", xcconfig: Path.project("DEV")),
        .release(name: "PROD", xcconfig: Path.project("PROD")),
    ]
}
