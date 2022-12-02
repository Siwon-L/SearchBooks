//
//  Project+Framework.swift
//  ProjectDescriptionHelpers
//
//  Created by 이시원 on 2022/12/02.
//

import ProjectDescription

extension Project {
  public static func staticFramework(
    name: String,
    targets: [Target]
  ) -> Project {
    return Project(
      name: name,
      organizationName: "SearchBooks",
      options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
      ),
      targets: targets,
      schemes: []
    )
  }
}

extension Target {
  public static func staticFrameworkTargets(
    name: String,
    platform: Platform,
    appDependencies: [TargetDependency],
    testDependencies: [TargetDependency]
  ) -> [Target] {
    let appTarget = Target(
      name: name,
      platform: platform,
      product: .staticFramework,
      bundleId: "com.SearchBooks.\(name)",
      deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: [],
      dependencies: appDependencies
    )
    
    let testTarget = Target(
      name: "\(name)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "com.SearchBooks.\(name)Tests",
      deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [.target(name: name)] + testDependencies
    )
    
    return [appTarget, testTarget]
  }
}

