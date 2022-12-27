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
    case changeSort
  }
  
  enum Mutation {
    case setSort
    case setBooks(Books, String)
    case addBooks(Books)
    case onError(Error)
    case setLoading(Bool)
  }
  
  struct State {
    var bookCount: Int = 0
    var books: [Book] = []
    var sort: Sort = .sim
    var errorMessage: String? = nil
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
    case .changeSort:
      guard let query = currentState.query else { return .never() }
      let result = useCase.searchBooks(
        query: query,
        sort: currentState.sort == .sim ? .date : .sim
      )
      return Observable.concat([
        .just(.setSort),
        result.map { Mutation.setBooks($0, query) }
          .catch { .just(.onError($0)) }
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.errorMessage = nil
    switch mutation {
    case .setSort:
      newState.sort = newState.sort == .sim ? .date : .sim
      return newState
    case .setBooks(let books, let query):
      newState.books = books.items
      newState.bookCount = books.total
      newState.query = query
      newState.nextStart = books.start + books.display
      newState.display = books.display
      return newState
    case .addBooks(let books):
      newState.books += books.items
      newState.nextStart += books.display
      return newState
    case .setLoading(let isLoading):
      newState.isLoding = isLoading
      return newState
    case .onError(let error):
      guard let error = error as? SearchServiceError else { return newState }
      newState.errorMessage = error.failureReason
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

