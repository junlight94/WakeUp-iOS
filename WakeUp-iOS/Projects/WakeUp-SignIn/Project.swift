import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvPlugin

let project = Project.makeModule(
    name: "\(Environment.workspaceName)-SignIn",
    targets: [.app, .unitTest],
    internalDependencies: [
        .Features.Signin.Feature,
        .data
    ],
    infoPlist: Project.signInInfoPlist)
