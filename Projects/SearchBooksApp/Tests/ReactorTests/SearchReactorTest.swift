//
//  SearchReactorTest.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2023/01/26.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import XCTest
@testable import SearchBooksApp

final class SearchReactorTest: XCTestCase {
  var sut: SearchReactor!
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
      isFavorites: false
    )
    
    dummyBooks = Books(
      total: 2,
      items: [item],
      start: 0,
      display: 1
    )
    
    useCase = StubSearchBookUseCase(books: dummyBooks, favorites: [])
    sut = SearchReactor(useCase: useCase)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    useCase = nil
    dummyBooks = nil
    item = nil
  }
  
  func test_searchBooks_Action이_발생하면_dummy가_State의_item에_저장된다() {
    // given
    
    // when
    sut.action.onNext(.searchBooks("SearchBook"))
    // then
    XCTAssertEqual(sut.currentState.items, dummyBooks.items)
    XCTAssertEqual(sut.currentState.bookCount, 2)
  }
  
  func test_loadNextPage_Action이_발생하면_State의_items에_값이_추가된다() {
    // given
    sut.action.onNext(.searchBooks("SearchBook"))
    // when
    sut.action.onNext(.loadNextPage(2))
    // then
    XCTAssertEqual(sut.currentState.items.count, 2)
  }
  
  func test_sortButtonDidTap_Action이_발생하면_State의_Sort가_date로_변경된다() {
    // given
    sut.action.onNext(.searchBooks("SearchBook"))
    // when
    sut.action.onNext(.sortButtonDidTap)
    // then
    XCTAssertEqual(sut.currentState.sort, .date)
  }
  
  func test_item의_isFavorites가_false일_때_favoritesButtonDidTap_Action이_발생하면_useCase의_addFavoritesBook호출된다() {
    // given
    sut.action.onNext(.searchBooks("SearchBook"))
    // when
    sut.action.onNext(.favoritesButtonDidTap("111", 0))
    // then
    XCTAssertEqual(useCase.favorites.first!, "111")
    XCTAssertEqual(useCase.addFavoritesBookCallCount, 1)
  }
  
  func test_item의_isFavorites가_true일_때_favoritesButtonDidTap_Action이_발생하면_useCase의_removeFavoritesBook호출된다() {
    // given
    item.isFavorites = true
    useCase.books.items = [item]
    useCase.favorites.append("111")
    sut.action.onNext(.searchBooks("SearchBook"))
    // when
    sut.action.onNext(.favoritesButtonDidTap("111", 0))
    // then
    XCTAssertEqual(useCase.favorites.first, nil)
    XCTAssertEqual(useCase.removeFavoritesBookCallCount, 1)
  }
  
  func test_changedFavoriteState_Action이_발생하면_넘겨받은_isbn에_해당하는_book의_isFavorites값이_변경된다() {
    // given
    sut.action.onNext(.searchBooks("SearchBook"))
    // when
    sut.action.onNext(.changedFavoriteState("111"))
    // then
    XCTAssertEqual(sut.currentState.items.first!.isFavorites, true)
  }
  
  func test_itemSelected_Action이_발생하면_State의_selectedBook에_저장된다() {
    // given
    let indexPath = IndexPath(row: 0, section: 0)
    sut.action.onNext(.searchBooks("SearchBook"))
    // when
    sut.action.onNext(.itemSelected(indexPath))
    // then
    XCTAssertEqual(sut.currentState.selectedBook!, dummyBooks.items.first!)
  }
}
