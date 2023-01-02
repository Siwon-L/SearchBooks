//
//  SearchCoordinator.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/19.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let favoritesBookStorage = FavoritesBookStorage()
    let networkService = NetworkService()
    let repository = BooksRepository(networkService: networkService, favoritesBookStorage: favoritesBookStorage)
    let useCase = SearchBookUseCase(repository: repository)
    let reactor = SearchReactor(useCase: useCase)
    let searchViewController = SearchViewController(reactor: reactor)
    searchViewController.coordinator = self
    navigationController.pushViewController(searchViewController, animated: true)
  }
}
