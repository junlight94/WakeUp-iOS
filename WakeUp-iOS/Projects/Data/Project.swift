import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Data",
    targets: [.staticFramework],
    internalDependencies: [
        .Modules.network
    ]
)
