//
//  Environment.swift
//  MyPlugin
//
//  Created by Junyoung on 2023/08/23.
//

import ProjectDescription

public enum Environment {
    public static let workspaceName = "WakeUp"
}

public extension Project {
    enum Environment {
        public static let workspaceName = "WakeUp"
        public static let deploymentTarget = DeploymentTarget.iOS(targetVersion: "13.0", devices: [.iphone])
        public static let platform = Platform.iOS
        public static let bundlePrefix = "com.csm.wakeup"
    }
}
