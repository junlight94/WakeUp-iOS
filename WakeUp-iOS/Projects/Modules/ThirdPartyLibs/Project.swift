import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLibs",
    targets: [.dynamicFramework],
    internalDependencies: [
        .SPM.Moya,
        .SPM.RxCocoa,
        .SPM.RxRelay,
        .SPM.RxSwift,
        .SPM.RxKeyboard,
        .SPM.Swinject,
        .SPM.Then,
        .SPM.AgoraRtcKit,
        .SPM.AgoraUIKit,
        .Carthage.FlexLayout,
        .Carthage.PinLayout
    ]
)
