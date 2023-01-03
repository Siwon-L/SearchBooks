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
      $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.47)
      $0.height.equalTo(200)
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
      $0.width.equalToSuperview().inset(8)
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    descriptionLable.snp.makeConstraints {
      $0.width.equalToSuperview().inset(8)
      $0.top.equalTo(infoStackView.snp.bottom).offset(8)
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
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
