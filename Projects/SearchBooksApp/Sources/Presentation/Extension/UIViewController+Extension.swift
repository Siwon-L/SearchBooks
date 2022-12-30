//
//  UIViewController+Extension.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/29.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import UIKit

import RxSwift

extension UIViewController {
  var showErrorAlert: Binder<String?> {
    return Binder(self) { owner, message in
      let alert = UIAlertController.makeAlert(message: message)
      owner.present(alert, animated: true)
    }
  }
}
