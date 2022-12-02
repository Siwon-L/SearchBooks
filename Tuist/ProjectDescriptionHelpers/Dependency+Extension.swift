//
//  Filess.swift
//  ProjectDescriptionHelpers
//
//  Created by 이시원 on 2022/12/02.
//

import ProjectDescription

public extension TargetDependency {
  static let rxSwift: TargetDependency = .external(name: "RxSwift")
  static let rxRelay: TargetDependency = .external(name: "RxRelay")
  static let rxCocoa: TargetDependency = .external(name: "RxCocoa")
  static let snapKit: TargetDependency = .external(name: "SnapKit")
  static let reactorKit: TargetDependency = .external(name: "ReactorKit")
}

