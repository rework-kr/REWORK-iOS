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
        .unitTests(baseModule: .feature(.IntroFeature), dependencies: [
            .Project.Features.IntroFeature
        ]),
        
        .demo(baseModule: .feature(.IntroFeature), dependencies: [
            .Project.Features.IntroFeature
        ]),
    ]
)

