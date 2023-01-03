//
//  DetailCoordinator.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2023/01/02.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import UIKit

final class DetailCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start(book: Book) {
    let favoritesBookStorage = FavoritesBookStorage()
    let networkService = NetworkService()
    let repository = BooksRepository(networkService: networkService, favoritesBookStorage: favoritesBookStorage)
    let useCase = SearchBookUseCase(repository: repository)
    let reactor = DetailReactor(useCase: useCase, book: book)
    let detailViewController = DetailViewController(reactor: reactor)
    detailViewController.coordinator = self
    navigationController.pushViewController(detailViewController, animated: true)
  }
  
  func removeCoordinator() {
    parentCoordinator?.removeChildCoordinator(child: self)
  }
}
