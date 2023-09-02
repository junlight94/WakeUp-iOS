import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvPlugin

let project = Project.makeModule(
    name: "\(Environment.workspaceName)-WaitingRoom",
    targets: [.app, .unitTest],
    internalDependencies: [
        .Features.WaitingRoom.Feature,
        .data
    ],
    infoPlist: Project.waitingRoomInfoPlist)
