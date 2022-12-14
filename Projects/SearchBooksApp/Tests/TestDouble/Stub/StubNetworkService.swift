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
      Task {
        do {
          let data = try await self.request(endpoint: endpoint)
          single(.success(data))
        } catch {
          single(.failure(error))
        }
      }
      return Disposables.create()
    }.asObservable()
  }
  
  func request(endpoint: SearchBooksApp.Endpoint) async throws -> Data {
    requestCallCount += 1
    if isSuccess {
      return data
    } else {
      throw SearchServiceError.network(reason: .badRequest)
    }
  }
}
