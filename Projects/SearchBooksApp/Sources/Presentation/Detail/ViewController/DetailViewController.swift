//
//  DetailViewController.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2023/01/02.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DetailViewController: UIViewController {
  private let mainView = DetailView()
  private let favoritesButton = UIBarButtonItem()
  private let disposeBag = DisposeBag()
  private let reactor: DetailReactor
  weak var coordinator: DetailCoordinator?
  
  init(reactor: DetailReactor) {
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
    navigationItem.rightBarButtonItem = favoritesButton
    favoritesButton.tintColor = .systemYellow
  }
  
  private func layout() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bind(_ reactor: DetailReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
  
  private func bindAction(_ reactor: DetailReactor) {
    favoritesButton.rx.tap
      .map {
        NotificationCenter.default.post(
          name: .chagedFavoriteValue,
          object: reactor.currentState.item.isbn
        )
        return DetailReactor.Action.favoritesButtonDidTap
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(_ reactor: DetailReactor) {
    reactor.state.map { $0.item }
      .distinctUntilChanged()
      .bind(to: mainView.setContent)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.title }
      .distinctUntilChanged()
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.isFavorites }
      .distinctUntilChanged()
      .bind(to: setFavoritesButtonImage)
      .disposed(by: disposeBag)
  }
}

extension DetailViewController {
  private var setFavoritesButtonImage: Binder<Bool> {
    return Binder(self) { owner, isFavorites in
      let image = isFavorites ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
      owner.favoritesButton.image = image
    }
  }
}
