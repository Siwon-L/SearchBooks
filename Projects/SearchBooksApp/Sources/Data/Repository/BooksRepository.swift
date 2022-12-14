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
        group.addTask { [weak self] in
          guard let data = try await self?.networkService.request(endpoint: endpoint) else { return nil }
          guard let book = try? self?.decoder.decode(BooksDTO.self, from: data) else {
            throw SearchServiceError.decode(reason: .decodeFailure(BooksDTO.self))
          }
          return book.items.first?.toDomain
        }
      }
      for try await book in group {
        books.append(book)
      }
    })
    return books
  }
}
