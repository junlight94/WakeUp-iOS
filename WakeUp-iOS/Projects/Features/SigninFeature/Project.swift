import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "SigninFeature",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .Features.BaseFeatureDependency
    ]
)
