import Foundation
import ProjectDescription

public extension TargetDependency {
    static func feature(
        target: ModulePaths.Feature,
        type: MicroTargetType = .empty
    ) -> TargetDependency {
        .project(
            target: target.targetName(suffix: type),
            path: .relativeToFeature(target.rawValue)
        )
    }

    static func module(
        target: ModulePaths.Module,
        type: MicroTargetType = .empty
    ) -> TargetDependency {
        .project(
            target: target.targetName(suffix: type),
            path: .relativeToModule(target.rawValue)
        )
    }

    static func userInterface(
        target: ModulePaths.UserInterface,
        type: MicroTargetType = .empty
    ) -> TargetDependency {
        .project(
            target: target.targetName(suffix: type),
            path: .relativeToUserInterfaces(target.rawValue)
        )
    }
    
    static func domain(
        target: ModulePaths.Domain,
        type: MicroTargetType = .empty
    ) -> TargetDependency {
        .project(
            target: target.targetName(suffix: type),
            path: .relativeToDomain(target.rawValue)
        )
    }
}
