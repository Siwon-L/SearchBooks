//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 이시원 on 2022/12/02.
//

import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: [
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.6.0")),
    .remote(url: "https://github.com/ReactorKit/ReactorKit.git",requirement: .upToNextMajor(from: "3.0.0"))
  ],
  platforms: [.iOS]
)
