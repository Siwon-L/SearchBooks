//
//  SearchReactor.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/22.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

import ReactorKit

final class SearchReactor: Reactor {
  let initialState: State
  let useCase: SearchBookUseCaseable
  
  enum Action {
    case searchBooks(String)
    case loadNextPage(Int)
    case sortButtonDidTap
    case favoritesButtonDidTap(String, Int)
    case changedFavoriteState(String)
    case itemSelected(IndexPath)
  }
  
  enum Mutation {
    case changeSort
    case setBooks(Books, String)
    case addBooks(Books)
    case onError(Error)
    case setLoading(Bool)
    case favoritesValue(Bool, Int)
    case selectedBook(Book)
    case none
  }
  
  struct State {
    var bookCount: Int = 0
    var items: [Book] = []
    var sort: Sort = .sim
    var errorMessage: String? = nil
    var selectedBook: Book? = nil
    fileprivate var query: String? = nil
    fileprivate var nextStart = 0
    fileprivate var display = 0
    fileprivate var isLoding = false
  }
  
  init(useCase: SearchBookUseCaseable) {
    self.useCase = useCase
    self.initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchBooks(let query):
      return Observable.concat([
        .just(.setLoading(true)),
        useCase.searchBooks(query: query, sort: currentState.sort)
          .map { Mutation.setBooks($0, query) }
          .catch { .just(.onError($0)) },
        .just(.setLoading(false))
      ])
    case .loadNextPage(let prefetchRow):
      guard checkLoadable(prefetchRow: prefetchRow) else { return .never() }
      guard let query = currentState.query else { return .never() }
      return Observable.concat([
        .just(.setLoading(true)),
        useCase.searchBooks(
          query: query,
          display: currentState.display,
          start: currentState.nextStart,
          sort: currentState.sort)
        .map { Mutation.addBooks($0) }
          .catch { .just(.onError($0)) },
        .just(.setLoading(false))
      ])
    case .sortButtonDidTap:
      guard let query = currentState.query else { return .never() }
      let result = useCase.searchBooks(
        query: query,
        sort: currentState.sort == .sim ? .date : .sim
      )
      return Observable.concat([
        .just(.changeSort),
        result.map { Mutation.setBooks($0, query) }
          .catch { .just(.onError($0)) }
      ])
    case .favoritesButtonDidTap(let isbn, let index):
      var newFavoriteValue = false
      if currentState.items[index].isFavorites {
        useCase.removeFavoritesBook(isbn: isbn)
      } else {
        useCase.addFavoritesBook(isbn: isbn)
        newFavoriteValue = true
      }
      return .just(.favoritesValue(newFavoriteValue, index))
    case .changedFavoriteState(let isbn):
      let items = currentState.items
      guard let index = items.firstIndex(where: { $0.isbn == isbn }) else { return .just(.none) }
      return .just(.favoritesValue(!items[index].isFavorites, index))
    case .itemSelected(let indexPath):
      return .just(.selectedBook(currentState.items[indexPath.row]))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.errorMessage = nil
    newState.selectedBook = nil
    switch mutation {
    case .changeSort:
      newState.sort = newState.sort == .sim ? .date : .sim
      return newState
    case .setBooks(let books, let query):
      newState.items = books.items
      newState.bookCount = books.total
      newState.query = query
      newState.nextStart = books.start + books.display
      newState.display = books.display
      return newState
    case .addBooks(let books):
      newState.items += books.items
      newState.nextStart += books.display
      return newState
    case .setLoading(let isLoading):
      newState.isLoding = isLoading
      return newState
    case .onError(let error):
      guard let error = error as? SearchServiceError else { return newState }
      newState.errorMessage = error.failureReason
      return newState
    case .favoritesValue(let isFavorites, let index):
      newState.items[index].isFavorites = isFavorites
      return newState
    case .selectedBook(let book):
      newState.selectedBook = book
      return newState
    case .none:
      return newState
    }
  }
}

private extension SearchReactor {
  func checkLoadable(prefetchRow: Int) -> Bool {
    let paginationRow = currentState.nextStart - currentState.display / 3
    return currentState.nextStart <= currentState.bookCount
    && currentState.nextStart <= 1000
    && !currentState.isLoding
    && prefetchRow > paginationRow
  }
}

