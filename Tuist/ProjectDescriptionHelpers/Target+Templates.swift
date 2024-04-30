import ProjectDescription
import DependencyPlugin
import EnvironmentPlugin

extension Target {
    public static func unitTests(
        baseModule: ModulePaths,
        destination: Destinations = .iOS,
        product: Product = .unitTests,
        deploymentTargets: DeploymentTargets = env.deploymentTargets,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ["Tests/**"],
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency],
        settings: Settings? = nil
        
    ) -> Target {
        return Target(
            name: baseModule.targetName(suffix: .unitTests),
            destinations: destination,
            product: product,
            bundleId: "\(env.organizationName).\(baseModule.targetName(suffix: .empty)).Tests",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: nil,
            scripts: [],
            dependencies: dependencies + [.Project.Module.testableThirdPartyLib],
            settings: settings
            
        )
    }
    
    public static func demo(
        baseModule: ModulePaths,
        destination: Destinations = .iOS,
        product: Product = .app,
        deploymentTargets: DeploymentTargets = env.deploymentTargets,
        infoPlist: InfoPlist = .extendingDefault(with: [
            "UILaunchStoryboardName": "Launch Screen.storyboard"
        ]),
        sources: SourceFilesList = ["DemoApp/Sources/**"],
        resources: ResourceFileElements = ["DemoApp/Resources/**"],
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency],
        settings: Settings = .settings(base: [
            "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -all_load"
        ])
    ) -> Target {
        return Target(
            name: baseModule.targetName(suffix: .demoApp),
            destinations: destination,
            product: product,
            bundleId: "\(env.organizationName).\(baseModule.targetName(suffix: .empty)).demoApp",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: nil,
            scripts: [],
            dependencies: dependencies,
            settings: settings
            
        )
    }
}
