import ProjectDescription
import ProjectDescriptionHelpers
import EnvironmentPlugin
import DependencyPlugin

// MARK: - Project

let settings: Settings =
    .settings(
        base: env.baseSetting,
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ],
        defaultSettings: .recommended
    )

let targets: [Target] = [
    .init(name: env.name,
          destinations: .iOS,
          product: .app,
          productName: env.name, 
          bundleId: "\(env.organizationName).\(env.name)",
          deploymentTargets: env.deploymentTargets,
          infoPlist: .file(path: "Support/Info.plist"),
          sources: ["Sources/**"],
          resources: ["Resources/**"],
          entitlements: nil,
          //entitlements: "Support/\(env.name).entitlements",
          scripts: [],
          dependencies: [
            .Project.Features.IntroFeature,
            .Project.Domain.AuthDomain,
            .Project.Domain.UserDomain
          ],
          settings: .settings(
            base: env.baseSetting,
            configurations: [
                .debug(name: .debug, xcconfig: "XCConfig/Secrets.xcconfig"),
                .release(name: .release, xcconfig: "XCConfig/Secrets.xcconfig")
            ])
         ),
    .init(name: "\(env.name)Tests",
          destinations: .iOS,
          product: .unitTests,
          bundleId: "\(env.organizationName).\(env.name)Tests",
          deploymentTargets: .iOS("17.0"),
          infoPlist: .default,
          sources: ["Tests/**"],
          resources: nil,
          dependencies: [
            .target(name: env.name)
          ]
         )
]

let schemes: [Scheme] = [
    .init(
        name: "\(env.name)-DEBUG",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
        testAction: nil,
        runAction: .runAction(configuration: .debug),
        archiveAction: .archiveAction(configuration: .debug),
        profileAction: .profileAction(configuration: .debug),
        analyzeAction: .analyzeAction(configuration: .debug)
    ),
    .init(
        name: "\(env.name)-RELEASE",
        shared: true,
        buildAction: BuildAction(targets: ["\(env.name)"]),
        testAction: nil,
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
    )
]


// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project: Project =
    .init(name: env.name,
          organizationName: env.organizationName,
          packages: [],
          settings: settings,
          targets: targets,
          schemes: schemes
    )
