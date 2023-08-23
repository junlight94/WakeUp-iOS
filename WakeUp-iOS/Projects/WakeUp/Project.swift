import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvPlugin

let project = Project.makeModule(
    name: Environment.workspaceName,
    targets: [.app, .unitTest],
    internalDependencies: [
        .Features.RootFeature,
        .data
    ])
