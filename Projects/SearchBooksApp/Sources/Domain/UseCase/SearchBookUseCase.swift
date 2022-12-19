//
//  SearchBookUseCase.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

import RxSwift

protocol SearchBookUseCaseable {
  func searchBooks(query: String) -> Observable<Books>
  func searchBooks(query: String, display: Int, start: Int, sort: Sort) -> Observable<Books>
  func searchFavoritesBooks() -> Observable<[Book?]>
  func addFavoritesBook(isbn: String)
  func removeFavoritesBook(isbn: String)
}

final class SearchBookUseCase: SearchBookUseCaseable {
  private let repository: BooksRepositorable
  
  init(repository: BooksRepositorable) {
    self.repository = repository
  }
  
  func searchBooks(query: String) -> Observable<Books> {
    return searchBooks(query: query, display: 10, start: 1, sort: .sim)
  }
  
  func searchBooks(query: String, display: Int, start: Int, sort: Sort) -> Observable<Books> {
    return repository.searchBooks(
      query: query,
      display: display,
      start: start,
      sort: sort
    )
  }
  
  func searchFavoritesBooks() -> Observable<[Book?]> {
    return repository.searchFavoritesBooks()
  }
  
  func addFavoritesBook(isbn: String) {
    repository.addFavoritesBook(isbn: isbn)
  }
  
  func removeFavoritesBook(isbn: String) {
    repository.removeFavoritesBook(isbn: isbn)
  }
}
