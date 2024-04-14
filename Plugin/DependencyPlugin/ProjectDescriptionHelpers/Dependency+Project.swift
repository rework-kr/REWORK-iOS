import ProjectDescription

public extension TargetDependency {
    struct Project {
        public struct Features {}
        public struct Module {}
        public struct Domain {}
        public struct UserInterfaces {}
    }
}

public extension TargetDependency.Project.Features {
    static let BaseFeature = TargetDependency.feature(target: .BaseFeature)
    static let CommonFeature = TargetDependency.feature(target: .CommonFeature)
    static let IntroFeature = TargetDependency.feature(target: .IntroFeature)
    static let MainTabFeature = TargetDependency.feature(target: .MainTabFeature)
    static let HomeFeature = TargetDependency.feature(target: .HomeFeature)
}

public extension TargetDependency.Project.Module {
    static let ErrorModule = TargetDependency.module(target: .ErrorModule)
    static let KeychainModule = TargetDependency.module(target: .KeychainModule)
    static let Utility = TargetDependency.module(target: .Utility)
}

public extension TargetDependency.Project.Domain {
    static let BaseDomain = TargetDependency.domain(target: .BaseDomain)
    static let AuthDomain = TargetDependency.domain(target: .AuthDomain)
    static let UserDomain = TargetDependency.domain(target: .UserDomain)

}

public extension TargetDependency.Project.UserInterfaces {
    static let DesignSystem = TargetDependency.userInterface(target: .DesignSystem)
}
