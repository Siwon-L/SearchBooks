//
//  FavoritesViewController.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2022/12/29.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FavoritesViewController: UIViewController {
  private let favoritesTableView = UITableView()
  private let disposeBag = DisposeBag()
  private let reactor: FavoritesReactor
  
  weak var coordinator: FavoritesCoordinator?
  
  init(reactor: FavoritesReactor) {
    self.reactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    attribute()
    layout()
    bind(reactor)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.post(name: .viewWillAppear, object: nil)
  }
  
  private func attribute() {
    view.backgroundColor = .systemBackground
    navigationItem.title = "즐겨찾기"
    
    favoritesTableView.then {
      $0.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
      $0.separatorStyle = .none
    }
  }
  
  private func layout() {
    view.addSubview(favoritesTableView)
    
    favoritesTableView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bind(_ reactor: FavoritesReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
  
  private func bindAction(_ reactor: FavoritesReactor) {
    NotificationCenter.default.rx.notification(.viewWillAppear)
      .map { _ in FavoritesReactor.Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    favoritesTableView.rx.itemSelected
      .map { FavoritesReactor.Action.itemSelected($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(_ reactor: FavoritesReactor) {
    reactor.state.map { $0.items }
      .bind(to: favoritesTableView.rx.items(
        cellIdentifier: BookCell.identifier,
        cellType: BookCell.self
      )) { index, book, cell in
        cell.setContent(book: book)
        cell.favoritesButtonDidTap = { [weak self] in
          guard let self = self else { return }
          Observable.just((book.isbn, index))
            .map { isbn, index in
              NotificationCenter.default.post(name: .chagedFavoriteState, object: isbn)
              return FavoritesReactor.Action.favoritesButtonDidTap(isbn, index)
            }
            .bind(to: self.reactor.action)
            .disposed(by: self.disposeBag)
        }
      }.disposed(by: disposeBag)
    
    reactor.state.map { $0.errorMessage }
      .filter { $0 != nil }
      .bind(to: showErrorAlert)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.selectedBook }
      .compactMap { $0 }
      .bind(to: showDetailView)
      .disposed(by: disposeBag)
  }
}

extension FavoritesViewController {
  private var showDetailView: Binder<Book> {
    return Binder(self) { owner, book in
      owner.coordinator?.showDetailView(book: book)
    }
  }
}
