//
//  Coordinator.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/19.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get }
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
  func removeChildCoordinator(child: Coordinator) {
    childCoordinators.removeAll { $0 === child }
  }
}
