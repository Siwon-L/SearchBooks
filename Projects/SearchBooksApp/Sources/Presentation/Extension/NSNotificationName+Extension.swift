//
//  NSNotificationName+Extension.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/30.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

extension NSNotification.Name {
  static let viewWillAppear = NSNotification.Name("viewWillAppear")
  static let chagedFavoriteState = NSNotification.Name("chagedFavoriteState")
}
