import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.IntroFeature.rawValue,
    packages: [],
    targets: [
        .init(name: ModulePaths.Feature.IntroFeature.rawValue,
              destinations: .iOS,
              product: .staticFramework,
              productName: nil,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.IntroFeature.rawValue)",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["Sources/**"],
              resources: ["Resources/**"],
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Features.BaseFeature,
                .Project.Features.MainTabFeature,
                .Project.Domain.AuthDomain,
                .Project.Domain.UserDomain
              ],
              settings: nil
             ),
        .init(name: ModulePaths.Feature.IntroFeature.rawValue + "Tests",
              destinations: .iOS,
              product: .unitTests,
              productName: nil,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.IntroFeature.rawValue).Tests",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["Tests/**"],
              resources: nil,
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Features.IntroFeature,
                .Project.Module.testableThirdPartyLib
              ],
              settings: nil
             ),
        .init(name: ModulePaths.Feature.IntroFeature.rawValue + "DemoApp",
              destinations: .iOS,
              product: .app,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.IntroFeature.rawValue).demoApp",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["DemoApp/Sources/**"],
              resources: ["DemoApp/Resources/**"],
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Features.IntroFeature
              ],
              settings: .settings(base: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -all_load"])
              
             )
    ]
)

