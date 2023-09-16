//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/09/15.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "WUCalendar",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .core
    ],
    hasResources: true
)
