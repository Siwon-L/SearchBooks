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
  private let decoder: JSONDecoder
  
  init(networkService: NetworkServicable, decoder: JSONDecoder = .init()) {
    self.networkService = networkService
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
}
