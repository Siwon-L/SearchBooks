//
//  BookCell.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/20.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

import SnapKit
import Kingfisher

final class BookCell: UITableViewCell {
  static let identifier = "BookCell"
  
  private let bookImageView = UIImageView()
  private let titleLabel = UILabel()
  private let authorLabel = UILabel()
  private let discountLabel = UILabel()
  private let publisherLabel = UILabel()
  private let pubdateLabel = UILabel()
  private let infoStackView = UIStackView()
  private let favoritesButton = UIButton()
  
  var favoritesButtonDidTap: () -> Void = {}
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    attribute()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    selectionStyle = .none
    
    favoritesButton.then {
      $0.tintColor = .systemYellow
      $0.setImage(.init(systemName: "star"), for: .normal)
      $0.addTarget(self, action: #selector(favoritesButtonAction), for: .touchUpInside)
    }
    
    bookImageView.then {
      $0.contentMode = .scaleAspectFit
      $0.clipsToBounds = true
    }
    
    infoStackView.then {
      $0.addArrangedSubviews([
        authorLabel,
        publisherLabel,
        pubdateLabel,
        discountLabel
      ])
      $0.axis = .vertical
      $0.spacing = 4
    }
    
    titleLabel.then {
      $0.numberOfLines = 2
      $0.text = "Title"
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
    contentView.addSubviews([
      bookImageView,
      titleLabel,
      infoStackView,
      favoritesButton
    ])
    
    bookImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().inset(8)
      $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.47)
      $0.height.equalTo(180)
    }
    
    favoritesButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(10)
      $0.width.height.equalTo(30)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(bookImageView.snp.trailing).inset(-8)
      $0.top.equalToSuperview().inset(8)
      $0.trailing.equalTo(favoritesButton.snp.leading).inset(-8)
    }
    
    infoStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).inset(-8)
      $0.leading.equalTo(bookImageView.snp.trailing).inset(-8)
      $0.trailing.equalToSuperview().inset(8)
    }
  }
  
  func setContent(book: Book) {
    bookImageView.kf.setImage(with: URL(string: book.image))
    titleLabel.text = book.title
    authorLabel.text = "저자: \(book.author)"
    publisherLabel.text = "출판사: \(book.publisher)"
    pubdateLabel.text = "출판일: \(book.pubdate)"
    discountLabel.text = "가격: \(book.discount)원"
  @objc
  private func favoritesButtonAction() {
    favoritesButtonDidTap()
  }
}
