//
//  SearchViewController.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/20.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SearchViewController: UIViewController {
  private let booksTableView = UITableView()
  private let searchBar = UISearchBar()
  private let selectionSortView = SelectionSortView()
  private let disposeBag = DisposeBag()
  private let reactor: SearchReactor
  
  weak var coordinator: SearchCoordinator?
  
  init(reactor: SearchReactor) {
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
  
  private func attribute() {
    view.backgroundColor = .systemBackground
    
    searchBar.then {
      $0.placeholder = "검색어를 입력하세요."
    }
    
    navigationItem.then {
      $0.titleView = searchBar
    }
    
    booksTableView.then {
      $0.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
      $0.separatorStyle = .none
    }
  }
  
  private func layout() {
    view.addSubview(selectionSortView)
    selectionSortView.snp.makeConstraints {
      $0.top.trailing.leading.equalTo(view.safeAreaLayoutGuide)
    }
    
    view.addSubview(booksTableView)
    booksTableView.snp.makeConstraints {
      $0.top.equalTo(selectionSortView.snp.bottom)
      $0.bottom.trailing.leading.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bind(_ reactor: SearchReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
  
  private func bindAction(_ reactor: SearchReactor) {
    searchBar.rx.searchButtonClicked
      .map { [weak self] in SearchReactor.Action.searchBooks(self?.searchBar.text ?? "") }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  
    selectionSortView.rx.sortButtonTap
      .map { SearchReactor.Action.sortButtonDidTap }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    booksTableView.rx.prefetchRows
      .compactMap { $0.first?.row }
      .map { SearchReactor.Action.loadNextPage($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(.chagedFavoriteValue)
      .compactMap { $0.object as? String }
      .map { isbn in SearchReactor.Action.changedFavoriteState(isbn) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    booksTableView.rx.itemSelected
      .map { SearchReactor.Action.itemSelected($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(_ reactor: SearchReactor) {
    reactor.state.map { $0.bookCount }
      .distinctUntilChanged()
      .map { "검색 결과: \($0)권" }
      .bind(to: selectionSortView.rx.countText)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.items }
      .bind(to: booksTableView.rx.items(
        cellIdentifier: BookCell.identifier,
        cellType: BookCell.self
      )) { index, book, cell in
        cell.setContent(book: book)
        cell.favoritesButtonDidTap = { [weak self] in
          guard let self = self else { return }
          Observable.just((book.isbn, index))
            .map { isbn, index in SearchReactor.Action.favoritesButtonDidTap(isbn, index) }
            .bind(to: self.reactor.action)
            .disposed(by: self.disposeBag)
        }
      }.disposed(by: disposeBag)
    
    reactor.state.map { $0.sort }
      .distinctUntilChanged()
      .map { $0 == .sim ? "정확도순" : "출간일순" }
      .bind(to: selectionSortView.rx.sortText)
      .disposed(by: disposeBag)
    
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

extension SearchViewController {
  private var showDetailView: Binder<Book> {
    return Binder(self) { owner, book in
      owner.coordinator?.showDetailView(book: book)
    }
  }
}
