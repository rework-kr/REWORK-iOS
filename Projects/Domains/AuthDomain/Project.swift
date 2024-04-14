import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.AuthDomain.rawValue,
    product: .staticLibrary,
    dependencies: [
        .Project.Domain.BaseDomain
    ]
)

