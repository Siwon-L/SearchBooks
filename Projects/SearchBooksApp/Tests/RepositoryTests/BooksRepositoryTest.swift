//
//  BooksRepositoryTest.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import XCTest
@testable import SearchBooksApp

import RxSwift

final class BooksRepositoryTest: XCTestCase {
  private var disposeBag: DisposeBag!
  private var dummyData: Data!
  private var networkService: StubNetworkService!
  private var storage: StubFavoritesBookStorage!
  private var sut: BooksRepositorable!
  
  override func setUpWithError() throws {
    let booksDTO = BooksDTO(
      lastBuildDate: "Thu, 08 Dec 2022 21:25:32 +0900",
      total: 13622,
      start: 1,
      display: 10,
      items: [
        .init(
          title: "Book",
          link: "",
          image: "",
          author: "",
          discount: "1000",
          publisher: "",
          isbn: "1",
          description: "",
          pubdate: "")
      ]
    )
    dummyData = try! JSONEncoder().encode(booksDTO)
    disposeBag = .init()
    storage = .init(isbns: ["123", "111", "000"])
  }
  
  override func tearDownWithError() throws {
    networkService = nil
    sut = nil
    disposeBag = nil
    dummyData = nil
  }
  
  func test_searchBooks을_호출했을_때_네트워크_통신에_실패했으면_Error를_방출해야한다() {
    // given
    networkService = .init(data: dummyData, isSuccess: false)
    sut = BooksRepository(networkService: networkService, favoritesBookStorage: storage, decoder: .init())
    // when
    sut.searchBooks(
      query: "Book",
      display: 10,
      start: 1,
      sort: .sim
    )
      .subscribe { books in
        XCTFail()
      } onError: { error in
        let error = error as! SearchServiceError
        // then
        XCTAssertEqual(error.failureReason, "서비스 이용에 불편을 드려 죄송합니다. 잠시 후 다시 시도해주세요.")
        XCTAssertEqual(self.networkService.requestCallCount, 1)
      }.disposed(by: disposeBag)
  }
  
  func test_test_searchBooks을_호출했을_때_네트워크_통신에_성공했으면_Books를_방출해야한다() {
    // given
    networkService = .init(data: dummyData, isSuccess: true)
    sut = BooksRepository(networkService: networkService, favoritesBookStorage: storage, decoder: .init())
    // when
    sut.searchBooks(
      query: "Book",
      display: 10,
      start: 1,
      sort: .sim
    )
      .subscribe(onNext: { books in
        // then
        XCTAssertEqual(self.networkService.requestCallCount, 1)
        XCTAssertEqual(books.items.first!.title, "Book")
      }, onError: { error in
        XCTFail(error.localizedDescription)
      }).disposed(by: disposeBag)
  }
  
  func test_searchFavoritesBooks을_호출했을_때_네트워크_통신에_실패했으면_Error를_방출해야한다() async {
    // given
    networkService = .init(data: dummyData, isSuccess: false)
    sut = BooksRepository(networkService: networkService, favoritesBookStorage: storage, decoder: .init())
    // when
    do {
      let _ = try await sut.searchFavoritesBooks()
      XCTFail()
    } catch {
      // then
      let error = error as! SearchServiceError
      XCTAssertEqual(self.networkService.requestCallCount, 3)
      XCTAssertEqual(error.failureReason, "서비스 이용에 불편을 드려 죄송합니다. 잠시 후 다시 시도해주세요.")
    }
  }
  
  func test_searchFavoritesBooks을_호출했을_때_네트워크_통신에_성공했으면_Book배열을_방출해야한다() async {
    // given
    networkService = .init(data: dummyData, isSuccess: true)
    sut = BooksRepository(networkService: networkService, favoritesBookStorage: storage, decoder: .init())
    // when
    do {
      // then
      let books = try await sut.searchFavoritesBooks()
      XCTAssertEqual(books.count, 3)
      XCTAssertEqual(self.networkService.requestCallCount, 3)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
}
