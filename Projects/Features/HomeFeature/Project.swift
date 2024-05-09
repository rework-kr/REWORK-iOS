import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.HomeFeature.rawValue,
    packages: [],
    targets: [
        .init(name: ModulePaths.Feature.HomeFeature.rawValue,
              destinations: .iOS,
              product: .staticFramework,
              productName: nil,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.HomeFeature.rawValue)",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["Sources/**"],
              resources: ["Resources/**"],
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Features.BaseFeature,
                .Project.Domain.UserDomain
              ],
              settings: nil
             ),
        .unitTests(baseModule: .feature(.HomeFeature), dependencies: [
            .Project.Features.HomeFeature
        ]),
        
        .demo(baseModule: .feature(.HomeFeature), dependencies: [
            .Project.Features.HomeFeature
        ])
    ]
)

