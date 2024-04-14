import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "DesignSystem",
    platform: .iOS,
    product: .framework,
    dependencies: [],
    resources: ["Resources/**"]
)
