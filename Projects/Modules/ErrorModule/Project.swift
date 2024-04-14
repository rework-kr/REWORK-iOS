import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Module.ErrorModule.rawValue,
    product: .staticFramework
)

