//
//  BooksEndpointAPI.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

enum UserInformation {
    static let id = "i26N0Qa7mtyarosISrRd"
    static let secret = "2Tk3UfYTUc"
}

enum BooksEndpointAPI {
  enum Sort: String {
    case sim = "sim"
    case date = "date"
  }
  
  private var baseURL: String {
    return "https://openapi.naver.com"
  }
  
  case searchBooks(
    query: String,
    display: Int = 10,
    start: Int = 1,
    sort: Sort = .sim
  )
  
  var asEndpoint: Endpoint {
    switch self {
    case .searchBooks(let query, let display, let start, let sort):
      return Endpoint(
        base: baseURL,
        path: "/v1/search/book.json",
        method: .get,
        headers: [
          "X-Naver-Client-Id": UserInformation.id,
          "X-Naver-Client-Secret": UserInformation.secret
        ],
        queries: [
          "query": query,
          "display": display,
          "start": start,
          "sort": sort.rawValue
        ]
      )
    }
  }
}

