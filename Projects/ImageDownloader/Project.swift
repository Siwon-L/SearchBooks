//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이시원 on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
  name: "ImageDownloader",
  targets: Target.staticFrameworkTargets(
    name: "ImageDownloader",
    platform: .iOS,
    appDependencies: [],
    testDependencies: []
  )
)
