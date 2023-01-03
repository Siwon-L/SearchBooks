//
//  Book.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

struct Book: Equatable {
  let title: String
  let image: String
  let author: String
  let discount: String
  let publisher: String
  let isbn: String
  let description: String
  let pubdate: String
  var isFavorites: Bool = true
}
