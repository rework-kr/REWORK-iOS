import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.BaseDomain.rawValue,
    product: .staticLibrary,
    dependencies: [
        .Project.Module.ErrorModule,
        .Project.Module.KeychainModule,
        .Project.Module.Utility
    ]
)

