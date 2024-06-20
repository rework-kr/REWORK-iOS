import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Module.domainThirdPartyLib.rawValue,
    product: .staticFramework,
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxMoya,
        .SPM.Moya
    ]
)
