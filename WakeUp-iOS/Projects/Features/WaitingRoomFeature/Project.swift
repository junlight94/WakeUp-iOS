import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "WaitingRoomFeature",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .Features.BaseFeatureDependency
    ]
)
