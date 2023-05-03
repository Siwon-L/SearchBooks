//
//  DetailReactor.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2023/01/03.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import Foundation

import ReactorKit

final class DetailReactor: Reactor {
  let initialState: State
  let useCase: SearchBookUseCaseable
  
  enum Action {
    case favoritesButtonDidTap
  }
  
  enum Mutation {
    case favoritesValue(Bool)
    case onError(Error)
  }
  
  struct State {
    var title: String
    var isFavorites: Bool
    var item: Book
    var errorMessage: String? = nil
  }
  
  init(useCase: SearchBookUseCaseable, book: Book) {
    self.useCase = useCase
    self.initialState = State(
      title: book.title,
      isFavorites: book.isFavorites,
      item: book
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .favoritesButtonDidTap:
      var newFavoriteValue = false
      if currentState.isFavorites {
        useCase.removeFavoritesBook(isbn: currentState.item.isbn)
      } else {
        do {
          try useCase.addFavoritesBook(isbn: currentState.item.isbn)
          newFavoriteValue = true
        } catch {
          return .concat([
            .just(.onError(error)),
            .just(.favoritesValue(newFavoriteValue))
          ])
        }
      }
      return .just(.favoritesValue(newFavoriteValue))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.errorMessage = nil
    switch mutation {
    case .favoritesValue(let isFavorites):
      newState.isFavorites = isFavorites
      return newState
    case .onError(let error):
      newState.errorMessage = error.localizedDescription
      return newState
    }
  }
}
