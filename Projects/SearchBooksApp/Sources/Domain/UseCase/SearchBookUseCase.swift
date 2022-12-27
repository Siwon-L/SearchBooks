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
  func searchBooks(query: String, sort: Sort) -> Observable<Books>
  func searchBooks(query: String, display: Int, start: Int, sort: Sort) -> Observable<Books>
  func searchFavoritesBooks() -> Observable<[Book?]>
  func addFavoritesBook(isbn: String)
  func removeFavoritesBook(isbn: String)
  func isFavorites(isbn: String) -> Bool
}

final class SearchBookUseCase: SearchBookUseCaseable {
  private let repository: BooksRepositorable
  
  init(repository: BooksRepositorable) {
    self.repository = repository
  }
  
  func searchBooks(query: String, sort: Sort) -> Observable<Books> {
    return searchBooks(query: query, display: 20, start: 1, sort: sort)
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
  
  func isFavorites(isbn: String) -> Bool {
    return repository.getFavoritesList().contains(isbn)
  }
}
