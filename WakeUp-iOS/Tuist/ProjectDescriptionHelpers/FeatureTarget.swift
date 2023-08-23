//
//  FeatureTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 2023/08/23.
//

import Foundation
import ProjectDescription

public enum FeatureTarget {
    case app                // iOSApp
    case dynamicFramework
    case staticFramework
    case unitTest           // Unit Test
    case demo               // Feature Excutable Test

    public var hasFramework: Bool {
        switch self {
        case .dynamicFramework, .staticFramework: return true
        default: return false
        }
    }
    public var hasDynamicFramework: Bool { return self == .dynamicFramework }
}

