//
//  FavoritesReactor.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/29.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

import ReactorKit

final class FavoritesReactor: Reactor {
  let initialState: State
  let useCase: SearchBookUseCaseable
  
  enum Action {
    case viewWillAppear
    case favoritesButtonDidTap(String, Int)
    case itemSelected(IndexPath)
  }
  
  enum Mutation {
    case loadFavorites([Book])
    case onError(Error)
    case favoritesValue(Bool, Int)
    case selectedBook(Book)
  }
  
  struct State {
    var items: [Book] = []
    var errorMessage: String? = nil
    var selectedBook: Book? = nil
  }
  
  init(useCase: SearchBookUseCaseable) {
    self.useCase = useCase
    self.initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return useCase.searchFavoritesBooks()
        .map { Mutation.loadFavorites($0.compactMap { $0 }) }
        .catch { .just(.onError($0)) }
    case .favoritesButtonDidTap(let isbn, let index):
      var newFavoriteValue = false
      if currentState.items[index].isFavorites {
        useCase.removeFavoritesBook(isbn: isbn)
      } else {
        useCase.addFavoritesBook(isbn: isbn)
        newFavoriteValue = true
      }
      return .just(.favoritesValue(newFavoriteValue, index))
    case .itemSelected(let indexPath):
      return .just(.selectedBook(currentState.items[indexPath.row]))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.errorMessage = nil
    newState.selectedBook = nil
    switch mutation {
    case .loadFavorites(let items):
      newState.items = items
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
    }
  }
}
