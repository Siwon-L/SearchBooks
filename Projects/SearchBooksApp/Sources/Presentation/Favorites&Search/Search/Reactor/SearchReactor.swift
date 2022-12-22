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
    case loadNextPage
    case changeSort
  }
  
  enum Mutation {
    case setSort
    case setBooks(Books, String)
    case addBooks(Books)
    case onError(Error)
  }
  
  struct State {
    var bookCount: Int = 0
    var books: [Book] = []
    var sort: Sort = .sim
    var errorMessage: String? = nil
    var query: String? = nil
    var page = 1
  }
  
  init(useCase: SearchBookUseCaseable) {
    self.useCase = useCase
    self.initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchBooks(let query):
      let result = useCase.searchBooks(query: query, sort: currentState.sort)
      return result.map { Mutation.setBooks($0, query) }
        .catch { .just(.onError($0)) }
    case .loadNextPage:
      guard let query = currentState.query else { return .never() }
      print(currentState.page)
      return useCase.searchBooks(
        query: query,
        display: 10,
        start: currentState.page,
        sort: currentState.sort)
      .map { Mutation.addBooks($0) }
      .catch { .just(.onError($0)) }
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
    switch mutation {
    case .setSort:
      var newState = state
      newState.sort = newState.sort == .sim ? .date : .sim
      return newState
    case .setBooks(let books, let query):
      var newState = state
      newState.books = books.items
      newState.bookCount = books.total
      newState.query = query
      newState.page = 1
      return newState
    case .addBooks(let books):
      var newState = state
      if newState.page > 1000 {
        return newState
      } else {
        newState.books += books.items
        newState.page += 10
        return newState
      }
    case .onError(let error):
      var newState = state
      guard let error = error as? SearchServiceError else { return newState }
      newState.errorMessage = error.failureReason
      return newState
    }
  }
}
