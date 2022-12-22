//
//  UIView+Extension.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/22.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach {
      addSubview($0)
    }
  }
}
