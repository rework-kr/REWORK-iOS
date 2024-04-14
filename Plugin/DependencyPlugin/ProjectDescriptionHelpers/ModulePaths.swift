import Foundation

public enum ModulePaths {
    case feature(Feature)
    case module(Module)
    case userInterface(UserInterface)
    case domain(Domain)
}

extension ModulePaths: MicroTargetPathConvertable {
    public func targetName(type: MicroTargetType) -> String {
        switch self {
        case let .feature(module as any MicroTargetPathConvertable),
            let .module(module as any MicroTargetPathConvertable),
            let .userInterface(module as any MicroTargetPathConvertable),
            let .domain(module as any MicroTargetPathConvertable):
            return module.targetName(type: type)
        }
    }
}

public extension ModulePaths {
    enum Feature: String, MicroTargetPathConvertable {
        case BaseFeature
        case IntroFeature
        case CommonFeature
        case MainTabFeature
        case HomeFeature
    }
}

public extension ModulePaths {
    enum Domain: String, MicroTargetPathConvertable {
        case BaseDomain
        case AuthDomain
        case UserDomain
    }
}

public extension ModulePaths {
    enum Module: String, MicroTargetPathConvertable {
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
    case sources = ""
    case testing = "Testing"
    case unitTest = "Tests"
    case demo = "Demo"
}

public protocol MicroTargetPathConvertable {
    func targetName(type: MicroTargetType) -> String
}

public extension MicroTargetPathConvertable where Self: RawRepresentable {
    func targetName(type: MicroTargetType) -> String {
        "\(self.rawValue)\(type.rawValue)"
    }
}
