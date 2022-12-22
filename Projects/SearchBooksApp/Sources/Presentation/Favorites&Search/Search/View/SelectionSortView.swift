//
//  SelectionSortView.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/22.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SelectionSortView: UIView {
  fileprivate let booksCountLabel = UILabel()
  fileprivate let selectedSortLabel = UILabel()
  fileprivate let selectionSortButton = UIButton()
  private let sortStackView = UIStackView()
  
  init() {
    super.init(frame: .zero)
    attribute()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    backgroundColor = .systemGray6
    
    selectionSortButton.then {
      $0.setImage(.init(systemName: "arrow.up.arrow.down.circle"), for: .normal)
      $0.setImage(.init(systemName: "star.fill"), for: .selected)
      $0.tintColor = .label
    }
    
    booksCountLabel.then {
      $0.textAlignment = .center
      $0.text = "label"
    }
    selectedSortLabel.then {
      $0.textAlignment = .center
      $0.text = "label"
    }
    
    sortStackView.then {
      $0.addArrangedSubview(selectedSortLabel)
      $0.addArrangedSubview(selectionSortButton)
      $0.spacing = 6
      $0.alignment = .center
    }
  }
  
  private func layout() {
    addSubview(booksCountLabel)
    booksCountLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(8)
    }
    
    addSubview(sortStackView)
    sortStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(8)
    }
    
    selectionSortButton.imageView?.snp.makeConstraints {
      $0.width.height.equalTo(25)
    }
    
    snp.makeConstraints {
      $0.height.equalTo(sortStackView.snp.height).multipliedBy(1.5)
    }
  }
}

extension Reactive where Base: SelectionSortView {
  var sortButtonTap: ControlEvent<Void> {
    return base.selectionSortButton.rx.tap
  }
  
  var sortText: Binder<String?> {
    return base.selectedSortLabel.rx.text
  }
  
  var countText: Binder<String?> {
    return base.booksCountLabel.rx.text
  }
}
