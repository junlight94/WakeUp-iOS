//
//  Dependency+Project.swift
//  MyPlugin
//
//  Created by Junyoung on 2023/08/23.
//

import ProjectDescription

public extension Dep {
    struct Features {
        public struct Signin {}
        public struct WaitingRoom {}
        public struct Meeting {}
        public struct Calendar {}
    }
    struct Modules {}
}

// MARK: - Root
public extension Dep {
    static let data = Dep.project(target: "Data", path: .data)

    static let domain = Dep.project(target: "Domain", path: .domain)
    
    static let core = Dep.project(target: "Core", path: .core)
}

// MARK: - Features
public extension Dep.Features {
    static func project(name: String, group: String) -> Dep { .project(target: "\(group)\(name)", path: .relativeToFeature("\(group)\(name)")) }
    
    static let BaseFeatureDependency = TargetDependency.project(target: "BaseFeatureDependency", path: .relativeToFeature("BaseFeatureDependency"))
    
    static let RootFeature = TargetDependency.project(target: "RootFeature", path: .relativeToFeature("RootFeature"))
}

//MARK: Signin
public extension Dep.Features.Signin {
    static let group = "Signin"
    static let Feature = Dep.Features.project(name: "Feature", group: group)
}

//MARK: WaitingRoom
public extension Dep.Features.WaitingRoom {
    static let group = "WaitingRoom"
    static let Feature = Dep.Features.project(name: "Feature", group: group)
}

//MARK: Meeting
public extension Dep.Features.Meeting {
    static let group = "Meeting"
    static let Feature = Dep.Features.project(name: "Feature", group: group)
}

public extension Dep.Features.Calendar {
    static let group = "Calendar"
    static let Feature = Dep.Features.project(name: "Feature", group: group)
}

// MARK: - Modules
public extension Dep.Modules {
    static let dsKit = Dep.project(target: "DSKit", path: .relativeToModules("DSKit"))
    static let network = Dep.project(target: "Network", path: .relativeToModules("Network"))
    static let thirdPartyLibs = Dep.project(target: "ThirdPartyLibs", path: .relativeToModules("ThirdPartyLibs"))
}
