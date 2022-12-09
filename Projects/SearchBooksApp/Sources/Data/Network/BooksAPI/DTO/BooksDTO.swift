//
//  BooksDTO.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

struct BooksDTO: Codable {
  let lastBuildDate: String
  let total: Int
  let start: Int
  let display: Int
  let items: [BookDTO]
}

extension BooksDTO {
  var toDomain: Books {
    return Books(
      total: self.total,
      items: self.items.map { $0.toDomain }
    )
  }
}
