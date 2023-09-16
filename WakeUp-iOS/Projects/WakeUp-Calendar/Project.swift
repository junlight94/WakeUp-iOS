//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/09/16.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvPlugin

let project = Project.makeModule(
    name: "\(Environment.workspaceName)-Calendar",
    targets: [.app, .unitTest],
    internalDependencies: [
        .Features.Calendar.Feature,
        .data
    ],
    infoPlist: Project.waitingRoomInfoPlist)
