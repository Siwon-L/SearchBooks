//
//  InfoView.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2023/01/02.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import UIKit

import SnapKit

final class InfoView: UIView {
  private let stackView = UIStackView()
  private let titleLabel = UILabel()
  private let authorLabel = UILabel()
  private let discountLabel = UILabel()
  private let publisherLabel = UILabel()
  private let pubdateLabel = UILabel()
  
  init() {
    super.init(frame: .zero)
    attribute()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    stackView.then {
      $0.axis = .vertical
      $0.spacing = 8
    }
    
    titleLabel.then {
      $0.numberOfLines = 2
      $0.font = .preferredFont(forTextStyle: .title3)
    }
    
    authorLabel.then {
      $0.font = .preferredFont(forTextStyle: .body)
      $0.numberOfLines = 1
      $0.text = "저자: "
    }
    
    publisherLabel.then {
      $0.font = .preferredFont(forTextStyle: .body)
      $0.numberOfLines = 1
      $0.text = "출판사: "
    }
    
    pubdateLabel.then {
      $0.font = .preferredFont(forTextStyle: .body)
      $0.numberOfLines = 1
      $0.text = "출판일: "
    }
    
    discountLabel.then {
      $0.font = .preferredFont(forTextStyle: .body)
      $0.numberOfLines = 1
      $0.text = "가격: "
    }
  }
  
  private func layout() {
    stackView.addArrangedSubviews([
      titleLabel,
      authorLabel,
      publisherLabel,
      pubdateLabel,
      discountLabel
    ])
    
    addSubview(stackView)
    
    stackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func setContent(book: Book) {
    titleLabel.text = book.title
    authorLabel.text = "저자: \(book.author)"
    publisherLabel.text = "출판사: \(book.publisher)"
    pubdateLabel.text = "출판일: \(book.pubdate)"
    discountLabel.text = "가격: \(book.discount)원"
  }
}
