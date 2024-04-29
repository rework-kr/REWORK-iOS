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
        .SPM.RxCocoa,
        .SPM.RxDataSources,
        .SPM.RxKeyboard,
        .SPM.RxMoya,
        .SPM.Moya,
        .SPM.Kingfisher,
        .SPM.Quick,
        .SPM.Nimble,
        .SPM.Inject
    ]
)
