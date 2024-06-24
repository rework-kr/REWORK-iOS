import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.RootFeature.rawValue,
    packages: [],
    targets: [
        .init(name: ModulePaths.Feature.RootFeature.rawValue,
              destinations: .iOS,
              product: .staticFramework,
              productName: nil,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.RootFeature.rawValue)",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["Sources/**"],
              resources: ["Resources/**"],
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Features.BaseFeature,
                .Project.Features.SignInFeature,
                .Project.Features.MainTabFeature,
                .Project.Domain.AuthDomain
              ],
              settings: nil
             )
    ]
)

