import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "MeetingFeature",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .Features.BaseFeatureDependency
    ]
)
