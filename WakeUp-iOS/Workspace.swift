import ProjectDescription
import ProjectDescriptionHelpers
import EnvPlugin

// MARK: - Project

let workspace = Workspace(
    name: Environment.workspaceName,
    projects: [
        "Projects/**"
    ]
)
