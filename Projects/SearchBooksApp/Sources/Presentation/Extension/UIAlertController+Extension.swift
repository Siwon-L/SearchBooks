//
//  UIAlertController+Extension.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/22.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

extension UIAlertController {
  static func makeAlert(message: String?) -> UIAlertController {
    let alert = UIAlertController(
      title: nil,
      message: message,
      preferredStyle: .alert
    )
    let okAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(okAction)
    return alert
  }
}
