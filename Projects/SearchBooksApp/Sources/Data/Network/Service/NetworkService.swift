//
//  NetworkService.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

import RxSwift

protocol NetworkServicable {
  func request(endpoint: Endpoint) -> Observable<Data>
  func request(endpoint: Endpoint) async throws -> Data
}

final class NetworkService: NetworkServicable {
  private let urlSession: URLSession

  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func request(endpoint: Endpoint) -> Observable<Data> {
    return Single<Data>.create { single in
      Task { [weak self] in
        do {
          guard let data = try await self?.request(endpoint: endpoint) else { return }
          single(.success(data))
        } catch {
          single(.failure(error))
        }
      }
      return Disposables.create()
    }.asObservable()
  }
  
  func request(endpoint: Endpoint) async throws -> Data {
    let urlRequest = try endpoint.create()
    let (data, response) = try await urlSession.data(for: urlRequest)
    guard let response = response as? HTTPURLResponse else {
      throw SearchServiceError.network(reason: .invalidateResponse)
    }
    
    switch response.statusCode {
    case 200..<300: return data
    case 400: throw SearchServiceError.network(reason: .badRequest)
    case 401: throw SearchServiceError.network(reason:.unauthorized)
    case 404: throw SearchServiceError.network(reason:.notFound)
    case 500: throw SearchServiceError.network(reason:.internalServerError)
    case 503: throw SearchServiceError.network(reason:.serviceUnavailable)
    default: throw SearchServiceError.network(reason:.unknown)
    }
  }
}
