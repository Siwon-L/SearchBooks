//
//  FavoritesReactorTest.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2023/01/26.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import XCTest
@testable import SearchBooksApp

final class FavoritesReactorTest: XCTestCase {
  var sut: FavoritesReactor!
  var useCase: StubSearchBookUseCase!
  var dummyBooks: Books!
  var item: Book!
  
  override func setUpWithError() throws {
    item = Book(
      title: "SearchBook",
      image: "",
      author: "",
      discount: "",
      publisher: "",
      isbn: "111",
      description: "",
      pubdate: "",
      isFavorites: true
    )
    
    dummyBooks = Books(
      total: 2,
      items: [item],
      start: 0,
      display: 1
    )
    
    useCase = StubSearchBookUseCase(books: dummyBooks, favorites: ["111"])
    sut = FavoritesReactor(useCase: useCase)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    useCase = nil
    dummyBooks = nil
    item = nil
  }
  
  func test_viewWillAppear_Action이_발생하면_dummy가_State의_item에_저장된다() {
    // given
    
    // when
    sut.action.onNext(.viewWillAppear)
    // then
    XCTAssertEqual(sut.currentState.items, dummyBooks.items)
  }
  
  func test_item의_isFavorites가_ture일_때_favoritesButtonDidTap_Action이_발생하면_useCase의_removeFavoritesBook호출된다() {
    // given
    sut.action.onNext(.viewWillAppear)
    // when
    sut.action.onNext(.favoritesButtonDidTap("111", 0))
    // then
    XCTAssertEqual(useCase.favorites.first, nil)
    XCTAssertEqual(useCase.removeFavoritesBookCallCount, 1)
  }
  
  func test_item의_isFavorites가_false일_때_favoritesButtonDidTap_Action이_발생하면_useCase의_addFavoritesBook호출된다() {
    // given
    item.isFavorites = false
    useCase.books.items = [item]
    useCase.favorites.removeAll { $0 == "111" }
    sut.action.onNext(.viewWillAppear)
    // when
    sut.action.onNext(.favoritesButtonDidTap("111", 0))
    // then
    XCTAssertEqual(useCase.favorites.first!, "111")
    XCTAssertEqual(useCase.addFavoritesBookCallCount, 1)
  }
  
  func test_itemSelected_Action이_발생하면_State의_selectedBook에_저장된다() {
    // given
    let indexPath = IndexPath(row: 0, section: 0)
    sut.action.onNext(.viewWillAppear)
    // when
    sut.action.onNext(.itemSelected(indexPath))
    // then
    XCTAssertEqual(sut.currentState.selectedBook, item)
  }
}
