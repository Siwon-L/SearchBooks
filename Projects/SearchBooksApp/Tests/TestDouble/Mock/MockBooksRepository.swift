//
//  MockBooksRepository.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation
@testable import SearchBooksApp

import RxSwift

final class MockBooksRepository: BooksRepositorable {
  var searchBooksCallCount = 0
  
  func searchBooks(query: String, display: Int, start: Int, sort: Sort) -> Observable<Books> {
    searchBooksCallCount += 1
    return .empty()
  }
}