import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Module.testableThirdPartyLib.rawValue,
    product: .staticFramework,
    dependencies: [
        .SPM.Quick,
        .SPM.Nimble
    ]
)
