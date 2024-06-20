import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.AgendaDomain.rawValue,
    product: .staticLibrary,
    dependencies: [
        .Project.Domain.BaseDomain
    ]
)

