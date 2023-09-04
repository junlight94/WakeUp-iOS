import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvPlugin

let project = Project.makeModule(
    name: "\(Environment.workspaceName)-Meeting",
    targets: [.app, .unitTest],
    internalDependencies: [
        .Features.Meeting.Feature,
        .data
    ],
    infoPlist: Project.meetingInfoPlist)
