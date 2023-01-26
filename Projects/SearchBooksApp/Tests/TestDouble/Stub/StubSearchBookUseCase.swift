//
//  StubSearchBookUseCase.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2023/01/26.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import Foundation
@testable import SearchBooksApp

import RxSwift

final class StubSearchBookUseCase: SearchBookUseCaseable {
  var books: Books!
  var favorites: [String]
  var addFavoritesBookCallCount = 0
  var removeFavoritesBookCallCount = 0
  
  init(books: Books?, favorites: [String]) {
    self.books = books
    self.favorites = favorites
  }
  
  func searchBooks(query: String, sort: Sort) -> Observable<Books> {
    return .just(books)
  }
  
  func searchBooks(query: String, display: Int, start: Int, sort: Sort) -> Observable<Books> {
    return .just(books)
  }
  
  func searchFavoritesBooks() -> Observable<[Book?]> {
    return .just(books.items)
  }
  
  func addFavoritesBook(isbn: String) {
    favorites.append(isbn)
    addFavoritesBookCallCount += 1
  }
  
  func removeFavoritesBook(isbn: String) {
    favorites.removeAll { $0 == isbn }
    removeFavoritesBookCallCount += 1
  }
}
