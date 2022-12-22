//
//  UIStackView+Extension.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/22.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ views: [UIView]) {
    views.forEach {
      addArrangedSubview($0)
    }
  }
}
