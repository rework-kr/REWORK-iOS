import PackageDescription

let package = Package(
    name: "REWORKPackage",
    dependencies: [
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/devxoul/Then", from: "2.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git",from: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", from: "2.0.1"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.6.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.5.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.2.1")
    ]
)
