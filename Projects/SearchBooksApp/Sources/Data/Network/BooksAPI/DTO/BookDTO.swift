//
//  BooksDTO.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

struct BookDTO: Codable {
  let title: String
  let link: String
  let image: String
  let author: String
  let discount: String
  let publisher: String
  let isbn: String
  let description: String
  let pubdate: String
}
