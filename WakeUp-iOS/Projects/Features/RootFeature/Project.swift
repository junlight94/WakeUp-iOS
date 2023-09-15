import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "RootFeature",
    targets: [.unitTest, .dynamicFramework],
    internalDependencies: [
        .Features.Signin.Feature,
        .Features.Meeting.Feature,
        .Features.WaitingRoom.Feature,
        .Features.Calendar.Feature
    ]
)
