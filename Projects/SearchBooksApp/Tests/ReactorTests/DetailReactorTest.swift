//
//  DetailReactorTest.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2023/01/26.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import XCTest
@testable import SearchBooksApp

final class DetailReactorTest: XCTestCase {
  var sut: DetailReactor!
  var useCase: StubSearchBookUseCase!
  var dummyBook: Book!
  
  override func setUpWithError() throws {
    dummyBook = Book(
      title: "SearchBook",
      image: "",
      author: "",
      discount: "",
      publisher: "",
      isbn: "111",
      description: "",
      pubdate: "",
      isFavorites: false
    )
    
    useCase = StubSearchBookUseCase(books: nil, favorites: [])
    sut = DetailReactor(useCase: useCase, book: dummyBook)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    useCase = nil
    dummyBook = nil
  }
  
  func test_item의_isFavorites가_false일_때_favoritesButtonDidTap_Action이_발생하면_useCase의_addFavoritesBook호출된다() {
    // given
    
    // when
    sut.action.onNext(.favoritesButtonDidTap)
    // then
    XCTAssertEqual(useCase.favorites.first!, "111")
    XCTAssertEqual(useCase.addFavoritesBookCallCount, 1)
  }
  
  func test_item의_isFavorites가_true일_때_favoritesButtonDidTap_Action이_발생하면_useCase의_removeFavoritesBook호출된다() {
    // given
    dummyBook.isFavorites = true
    sut = DetailReactor(useCase: useCase, book: dummyBook)
    // when
    sut.action.onNext(.favoritesButtonDidTap)
    // then
    XCTAssertEqual(useCase.favorites.first, nil)
    XCTAssertEqual(useCase.removeFavoritesBookCallCount, 1)
  }
}

