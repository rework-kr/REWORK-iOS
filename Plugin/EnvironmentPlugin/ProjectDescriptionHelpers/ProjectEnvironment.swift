//
//  ProjectEnvironment.swift
//  MyPlugin
//
//  Created by YoungK on 4/13/24.
//

import Foundation
import ProjectDescription

public struct ProjectEnvironment {
    public let name: String
    public let organizationName: String
    @available(*, deprecated, message: "'DeploymentTarget' was deprecated, use instead of 'DeploymentTargets' and 'Destinations'")
    public let deploymentTarget: DeploymentTarget
    public let deploymentTargets: DeploymentTargets
    public let destinations : Destinations
    public let baseSetting: SettingsDictionary

   
}

public let env = ProjectEnvironment(
    name: "REWORK",
    organizationName: "youngkyu.song",
    deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
    deploymentTargets: .iOS("17.0"),
    destinations: .iOS,
    baseSetting: SettingsDictionary()
        .marketingVersion("1.0.0")
        .currentProjectVersion("0")
        .debugInformationFormat(DebugInformationFormat.dwarfWithDsym)
        .otherLinkerFlags(["-ObjC"])
        .bitcodeEnabled(false)
)
