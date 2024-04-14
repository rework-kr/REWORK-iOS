import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.CommonFeature.rawValue,
    packages: [],
    targets: [
        .init(name: ModulePaths.Feature.CommonFeature.rawValue,
              destinations: .iOS,
              product: .staticFramework,
              productName: nil,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.CommonFeature.rawValue)",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["Sources/**"],
              resources: ["Resources/**"],
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Features.BaseFeature
              ],
              settings: nil
             )
    ]
)

