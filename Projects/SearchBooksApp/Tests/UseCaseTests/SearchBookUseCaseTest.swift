//
//  SearchBookUseCaseTest.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import XCTest
@testable import SearchBooksApp

import RxSwift

final class SearchBookUseCaseTest: XCTestCase {
  private var sut: SearchBookUseCaseable!
  private var booksRepository: MockBooksRepository!
  
  override func setUpWithError() throws {
    booksRepository = .init()
    sut = SearchBookUseCase(repository: booksRepository)
  }
  
  override func tearDownWithError() throws {
    booksRepository = nil
    sut = nil
  }
  
  func test_searchBooks이_호출되었을_때_repository의_searchBooks가_호출되어야_한다() {
    // when
    _ = sut.searchBooks(query: "Book")
    
    // then
    XCTAssertEqual(booksRepository.searchBooksCallCount, 1)
  }
}
