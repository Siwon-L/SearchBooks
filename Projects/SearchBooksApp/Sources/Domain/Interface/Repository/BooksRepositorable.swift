//
//  BooksRepositorable.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

import RxSwift

protocol BooksRepositorable {
  func searchBooks(query: String, display: Int, start: Int, sort: Sort) -> Observable<Books>
}
