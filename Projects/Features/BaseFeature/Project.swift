import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.BaseFeature.rawValue,
    packages: [],
    targets: [
        .init(name: ModulePaths.Feature.BaseFeature.rawValue,
              destinations: .iOS,
              product: .staticFramework,
              productName: nil,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.BaseFeature.rawValue)",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["Sources/**"],
              resources: ["Resources/**"],
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Domain.BaseDomain,
                .Project.UserInterfaces.DesignSystem,
                .Project.Module.FeatureThirdPartyLib,
                .Project.Module.Utility
              ],
              settings: nil
             )
    ]
)

