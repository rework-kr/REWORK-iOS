import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: SwiftPackageManagerDependencies(
        baseSettings: .settings(
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ]
        )
    ),
    platforms: [.iOS]
)
