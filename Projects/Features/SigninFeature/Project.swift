import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.SignInFeature.rawValue,
    packages: [],
    targets: [
        .init(name: ModulePaths.Feature.SignInFeature.rawValue,
              destinations: .iOS,
              product: .staticFramework,
              productName: nil,
              bundleId: "\(env.organizationName).\(ModulePaths.Feature.SignInFeature.rawValue)",
              deploymentTargets: env.deploymentTargets,
              infoPlist: .default,
              sources: ["Sources/**"],
              resources: ["Resources/**"],
              entitlements: nil,
              scripts: [],
              dependencies: [
                .Project.Features.BaseFeature,
                .Project.Features.MainTabFeature,
                .Project.Domain.AuthDomain
              ],
              settings: nil
             ),
        .unitTests(baseModule: .feature(.SignInFeature), dependencies: [
            .Project.Features.SignInFeature
        ]),
        
        .demo(baseModule: .feature(.SignInFeature), dependencies: [
            .Project.Features.SignInFeature
        ]),
    ]
)

