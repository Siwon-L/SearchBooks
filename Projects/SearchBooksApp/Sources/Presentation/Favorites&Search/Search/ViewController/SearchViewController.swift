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
      $0.showsCancelButton = true
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
      .map { SearchReactor.Action.changeSort }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    booksTableView.rx.prefetchRows
      .map { _ in SearchReactor.Action.loadNextPage }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(_ reactor: SearchReactor) {
    reactor.state.map { $0.bookCount }
      .distinctUntilChanged()
      .map { "검색 결과: \($0)권" }
      .bind(to: selectionSortView.rx.countText)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.books }
      .bind(to: booksTableView.rx.items(
        cellIdentifier: BookCell.identifier,
        cellType: BookCell.self
      )) { _, book, cell in
        cell.setContent(book: book)
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
    
  }
  
  private var showErrorAlert: Binder<String?> {
    return Binder(self) { owner, message in
      let alert = UIAlertController.makeAlert(message: message)
      owner.present(alert, animated: true)
    }
  }
}
