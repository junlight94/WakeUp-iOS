import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLibs",
    targets: [.dynamicFramework],
    internalDependencies: [
        .SPM.Alamofire,
        .SPM.PinLayout,
        .SPM.RxCocoa,
        .SPM.RxRelay,
        .SPM.RxSwift,
        .SPM.Swinject,
        .SPM.Then,
        .Carthage.FlexLayout
    ]
)
