//
//  FavoritesCoordinator.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/19.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    
  }
}
