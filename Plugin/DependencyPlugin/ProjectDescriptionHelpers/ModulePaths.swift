import Foundation

public enum ModulePaths {
    case feature(Feature)
    case module(Module)
    case userInterface(UserInterface)
    case domain(Domain)
}

extension ModulePaths: MicroTargetPathConvertable {
    public func targetName(suffix: MicroTargetType) -> String {
        switch self {
        case let .feature(module as any MicroTargetPathConvertable),
            let .module(module as any MicroTargetPathConvertable),
            let .userInterface(module as any MicroTargetPathConvertable),
            let .domain(module as any MicroTargetPathConvertable):
            return module.targetName(suffix: suffix)
        }
    }
}

public extension ModulePaths {
    enum Feature: String, MicroTargetPathConvertable {
        case BaseFeature
        case SignInFeature
        case CommonFeature
        case MainTabFeature
        case HomeFeature
    }
}

public extension ModulePaths {
    enum Domain: String, MicroTargetPathConvertable {
        case BaseDomain
        case AuthDomain
        case AgendaDomain
    }
}

public extension ModulePaths {
    enum Module: String, MicroTargetPathConvertable {
        case testableThirdPartyLib
        case featureThirdPartyLib
        case ErrorModule
        case KeychainModule
        case Utility
    }
}

public extension ModulePaths {
    enum UserInterface: String, MicroTargetPathConvertable {
        case DesignSystem
    }
}

public enum MicroTargetType: String {
    case interface = "Interface"
    //case sources = ""
    case testing = "Testing"
    case unitTests = "Tests"
    case demoApp = "DemoApp"
    case empty = ""
}

public protocol MicroTargetPathConvertable {
    func targetName(suffix: MicroTargetType) -> String
}

public extension MicroTargetPathConvertable where Self: RawRepresentable {
    func targetName(suffix: MicroTargetType) -> String {
        "\(self.rawValue)\(suffix.rawValue)"
    }
}
