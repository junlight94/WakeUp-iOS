import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "CalendarFeature",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .Features.BaseFeatureDependency
    ]
)
