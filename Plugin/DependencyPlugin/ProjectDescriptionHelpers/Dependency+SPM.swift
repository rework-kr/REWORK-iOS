import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    // MARK: External
    static let Moya = TargetDependency.external(name: "Moya")
    static let RxMoya = TargetDependency.external(name: "RxMoya")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let RxDataSources = TargetDependency.external(name: "RxDataSources")
    static let RxKeyboard = TargetDependency.external(name: "RxKeyboard")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let Then = TargetDependency.external(name: "Then")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let ReactorKit = TargetDependency.external(name: "ReactorKit")
    static let Quick = TargetDependency.external(name: "Quick")
    static let Nimble = TargetDependency.external(name: "Nimble")
}
