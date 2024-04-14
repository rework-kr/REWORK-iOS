import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Module.Utility.rawValue,
    product: .staticFramework
)

