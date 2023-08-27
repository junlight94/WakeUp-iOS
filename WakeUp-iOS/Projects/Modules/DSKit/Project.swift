//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 2023/08/27.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DSKit",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .core
    ],
    hasResources: true
)

