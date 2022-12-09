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
  
  func request(endpoint: Endpoint) -> RxSwift.Observable<Data> {
    return request(endpoint: endpoint, callbackQueue: .mainCurrentOrAsync)
  }
  
  func request(endpoint: Endpoint, callbackQueue: SearchBooksApp.CallbackQueue) -> RxSwift.Observable<Data> {
    requestCallCount += 1
    if isSuccess {
      return .just(data)
    } else {
      return .error(SearchServiceError.network(reason: .badRequest))
    }
  }
}
