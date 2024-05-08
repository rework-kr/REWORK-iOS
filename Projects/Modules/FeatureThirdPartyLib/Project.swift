import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Module.featureThirdPartyLib.rawValue,
    product: .staticFramework,
    dependencies: [
        .SPM.ReactorKit,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.RxSwift,
        .SPM.RxDataSources,
        .SPM.RxKeyboard,
        .SPM.RxMoya,
        .SPM.Moya,
        .SPM.Kingfisher,
        .SPM.Inject,
        .SPM.NVActivityIndicatorView
    ]
)
