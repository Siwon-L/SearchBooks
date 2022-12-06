//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이시원 on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "SearchBooksApp",
  targets: Target.appTarget(
    name: "SearchBooksApp",
    platform: .iOS,
    appDependencies: [
      .snapKit,
      .rxSwift,
      .rxCocoa,
      .rxRelay,
      .reactorKit,
      .kingfisher
    ],
    testDependencies: [
      .rxSwift,
      .rxRelay,
      .reactorKit
    ]
  )
)
