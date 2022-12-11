//
//  BooksRepository.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

import RxSwift

final class BooksRepository: BooksRepositorable {
  private let networkService: NetworkServicable
  private let favoritesBookStorage: FavoritesBookStoragable
  private let decoder: JSONDecoder
  
  init(
    networkService: NetworkServicable,
    favoritesBookStorage: FavoritesBookStoragable,
    decoder: JSONDecoder = .init()
  ) {
    self.networkService = networkService
    self.favoritesBookStorage = favoritesBookStorage
    self.decoder = decoder
  }
  
  func searchBooks(
    query: String,
    display: Int,
    start: Int,
    sort: Sort
  ) -> Observable<Books> {
    let endpoint = BooksEndpointAPI.searchBooks(
      query: query,
      display: display,
      start: start,
      sort: sort
    ).asEndpoint
    return networkService.request(endpoint: endpoint)
      .decode(type: BooksDTO.self, decoder: decoder)
      .map { $0.toDomain }
  }
  
  func searchFavoritesBooks() async throws -> [Book?] {
    let endpoints = favoritesBookStorage.getValue
      .map { BooksEndpointAPI.searchBook(dIsbn: $0).asEndpoint }
    var books: [Book?] = []
    try await withThrowingTaskGroup(of: Book?.self, body: { group in
      for endpoint in endpoints {
        group.addTask {
          async let book = try await withCheckedThrowingContinuation({ [weak self] continuation in
            guard let self = self else { return }
            self.networkService.request(
              endpoint: endpoint,
              callbackQueue: .dispatch(.global())
            ) { result in
              switch result {
              case .success(let data):
                do {
                  let booksDTO = try self.decoder.decode(BooksDTO.self, from: data)
                  continuation.resume(returning: booksDTO.items.first?.toDomain)
                } catch {
                  continuation.resume(throwing: SearchServiceError.decode(reason: .decodeFailure(BooksDTO.self)))
                }
              case .failure(let error):
                continuation.resume(throwing: error)
              }
            }
          })
          return try await book
        }
      }
      for try await book in group {
        books.append(book)
      }
    })
    return books
  }
}
