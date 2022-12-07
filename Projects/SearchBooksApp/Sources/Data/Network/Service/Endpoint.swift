//
//  Endpoint.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

final class Endpoint {
  enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
  }
  
  private let base: String
  private let path: String
  private let method: HTTPMethod
  private let headers: [String: String]
  private let queries: [String: Any]
  private let payload: Data?

  init(
    base: String,
    path: String,
    method: HTTPMethod,
    headers: [String: String] = [:],
    queries: [String: Any] = [:],
    payload: Data? = nil
  ) {
    self.base = base
    self.path = path
    self.method = method
    self.headers = headers
    self.queries = queries
    self.payload = payload
  }

  func create() throws -> URLRequest {
    let url = try createURL()
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue

    headers.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }

    if method != .get, let httpBody = payload {
      request.httpBody = httpBody
    }

    return request
  }

  private func createURL() throws -> URL {
    let urlString = base + path

    var component = URLComponents(string: urlString)
    component?.queryItems = queries.map {
      URLQueryItem(name: $0.key, value: "\($0.value)")
    }

    guard let url = component?.url else {
      throw HTTPError.createURLError
    }

    return url
  }
}
