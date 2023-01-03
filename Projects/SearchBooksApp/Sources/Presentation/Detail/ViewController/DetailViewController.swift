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
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    attribute()
    layout()
    bind()
  }
  
  private func attribute() {
    view.backgroundColor = .systemBackground
  }
  
  private func layout() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bind() {
    bindAction()
    bindState()
  }
  
  private func bindAction() {
    
  }
  
  private func bindState() {
    
  }
}
