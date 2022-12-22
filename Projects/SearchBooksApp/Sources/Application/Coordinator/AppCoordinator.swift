//
//  AppCoordinator.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/19.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let tabBarController = UITabBarController()
    tabBarController.tabBar.backgroundColor = .systemBackground
    tabBarController.tabBar.tintColor = .label

    let searchNavigationController = UINavigationController()
    searchNavigationController.tabBarItem = UITabBarItem(
      title: "검색",
      image: UIImage(systemName: "magnifyingglass"),
      tag: 0
    )
    searchNavigationController.navigationBar.tintColor = .label
    
    let favoritesNavigationController = UINavigationController()
    favoritesNavigationController.tabBarItem = UITabBarItem(
      title: "즐겨찾기",
      image: UIImage(systemName: "star"),
      tag: 1
    )
    favoritesNavigationController.navigationBar.tintColor = .label

    tabBarController.viewControllers = [searchNavigationController, favoritesNavigationController]
    navigationController.viewControllers = [tabBarController]
    navigationController.setNavigationBarHidden(true, animated: false)

    let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)
    let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavigationController)
    
    favoritesCoordinator.parentCoordinator = self
    searchCoordinator.parentCoordinator = self

    childCoordinators.append(searchCoordinator)
    childCoordinators.append(favoritesCoordinator)
    searchCoordinator.start()
    favoritesCoordinator.start()
  }
}
