//
//  StubFavoritesBookStorage.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/10.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation
@testable import SearchBooksApp

import RxSwift

final class StubFavoritesBookStorage: FavoritesBookStoragable {
  var isbns: [String]
  
  init(isbns: [String]) {
    self.isbns = isbns
  }
  
  var getValue: Set<String> {
    return Set(isbns)
  }
  
  func addValue(_ isbn: String) {
    isbns.append(isbn)
  }
  
  func removeValue(_ isbn: String) {
    isbns.removeAll { $0 == isbn }
  }
}
