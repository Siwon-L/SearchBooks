//
//  DetailView.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2023/01/02.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import Kingfisher

final class DetailView: UIView {
  private let scrollView = UIScrollView()
  private let infoStackView = UIStackView()
  private let bookImageView = UIImageView()
  private let infoView = InfoView()
  private let descriptionLable = UILabel()
  
  
  init() {
    super.init(frame: .zero)
    attribute()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    scrollView.showsVerticalScrollIndicator = false
    infoStackView.spacing = 16
    descriptionLable.numberOfLines = 0
  }
  
  private func layout() {
    infoStackView.addArrangedSubviews([
      bookImageView,
      infoView
    ])
    
    bookImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().inset(8)
      $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.47)
      $0.height.equalTo(300)
    }
    
    scrollView.addSubviews([
      infoStackView,
      descriptionLable
    ])
    
    addSubview(scrollView)
    
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    infoStackView.snp.makeConstraints {
      $0.top.trailing.leading.equalToSuperview()
    }
    
    descriptionLable.snp.makeConstraints {
      $0.top.equalTo(infoStackView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  var setContent: Binder<Book> {
    return Binder(self) { owner, book in
      owner.bookImageView.kf.setImage(with: URL(string: book.image))
      owner.infoView.setContent(book: book)
      owner.descriptionLable.text = book.description
    }
  }
}
