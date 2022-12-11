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
  func request(
    endpoint: Endpoint,
    callbackQueue: CallbackQueue,
    completion: @escaping (Result<Data, Error>) -> Void
  )
}

final class NetworkService: NetworkServicable {
  private let urlSession: URLSession

  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func request(endpoint: Endpoint) -> Observable<Data> {
    return Single<Data>.create { [weak self] single in
      self?.request(endpoint: endpoint, callbackQueue: .mainCurrentOrAsync, completion: { result in
        switch result {
        case .success(let data):
          single(.success(data))
        case .failure(let error):
          single(.failure(error))
        }
      })
      return Disposables.create()
    }.asObservable()
  }
  
  func request(
    endpoint: Endpoint,
    callbackQueue: CallbackQueue,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    let callback: (Result<Data, Error>) -> Void = { result in
      callbackQueue.execute { completion(result) }
    }
    do {
      let urlRequest = try endpoint.create()
      
      urlSession.dataTask(with: urlRequest) { data, response, error in
        guard error == nil, let data = data else {
          callback(.failure(SearchServiceError.network(reason: .errorIsOccurred(error.debugDescription))))
          return
        }
        guard let response = response as? HTTPURLResponse else {
          callback(.failure(SearchServiceError.network(reason: .invalidateResponse)))
          return
        }
        
        switch response.statusCode {
        case 200..<300: callback(.success(data))
        case 400: callback(.failure(SearchServiceError.network(reason: .badRequest)))
        case 401: callback(.failure(SearchServiceError.network(reason:.unauthorized)))
        case 404: callback(.failure(SearchServiceError.network(reason:.notFound)))
        case 500: callback(.failure(SearchServiceError.network(reason:.internalServerError)))
        case 503: callback(.failure(SearchServiceError.network(reason:.serviceUnavailable)))
        default: callback(.failure(SearchServiceError.network(reason:.unknown)))
        }
      }.resume()
    } catch {
      callbackQueue.execute { completion(.failure(error)) }
    }
  }
}
