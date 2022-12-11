//
//  StubNetworkService.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2022/12/08.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation
@testable import SearchBooksApp

import RxSwift

final class StubNetworkService: NetworkServicable {
  let data: Data
  let isSuccess: Bool
  var requestCallCount = 0
  
  init(data: Data, isSuccess: Bool) {
    self.data = data
    self.isSuccess = isSuccess
  }
  
  func request(endpoint: Endpoint) -> Observable<Data> {
    return Single.create { single in
      self.request(endpoint: endpoint, callbackQueue: .mainCurrentOrAsync) { result in
        switch result {
        case .success(let data):
          single(.success(data))
        case .failure(let error):
          single(.failure(error))
        }
      }
      return Disposables.create()
    }.asObservable()
  }
  
  func request(endpoint: SearchBooksApp.Endpoint, callbackQueue: SearchBooksApp.CallbackQueue, completion: @escaping (Result<Data, Error>) -> Void) {
    requestCallCount += 1
    if isSuccess {
      callbackQueue.execute { completion(.success(self.data)) }
    } else {
      callbackQueue.execute { completion(.failure(SearchServiceError.network(reason: .badRequest))) }
    }
  }
}
