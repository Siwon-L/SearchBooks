//
//  SearchServiceError.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

enum SearchServiceError: LocalizedError {
  enum NetworkReason {
    case createURLRequestFailure
    case errorIsOccurred(_ error: String)
    case badRequest
    case unauthorized
    case notFound
    case internalServerError
    case serviceUnavailable
    case invalidateResponse
    case unknown
  }
  
  enum DecodeReason {
    case decodeFailure(Any.Type)
  }
  
  case network(reason: NetworkReason, fileID: String = #fileID, line: UInt16 = #line, column: UInt16 = #column)
  case decode(reason: DecodeReason, fileID: String = #fileID, line: UInt16 = #line, column: UInt16 = #column)
  
  var errorDescription: String? {
    let format = "%@(%u:%u): %@"
    
    switch self {
    case .network(let reason, let fileID, let line, let column):
      return String(format: "[Network] " + format, fileID, line, column, reason.description)
    case .decode(let reason, let fileID, let line, let column):
      return String(format: "[Decode] " + format, fileID, line, column, reason.description)
    }
  }
  
  var failureReason: String? {
    return "서비스 이용에 불편을 드려 죄송합니다. 잠시 후 다시 시도해주세요."
  }
}

extension SearchServiceError.NetworkReason {
  var description: String {
    switch self {
    case .createURLRequestFailure:
      return "잘못된 URL입니다."
    case .errorIsOccurred(let error):
      return "\(error)오류가 발생했습니다."
    case .badRequest:
      return "잘못된 요청입니다."
    case .unauthorized:
      return "유효하지 않은 인증입니다."
    case .notFound:
      return "요청한 페이지를 찾을 수 없습니다."
    case .internalServerError:
      return "현재 서버에 문제가 발생하였습니다."
    case .serviceUnavailable:
      return "현재 서비스 사용이 불가합니다."
    case .invalidateResponse:
      return "유효하지 않은 응답입니다."
    case .unknown:
      return "알 수 없는 오류가 발생했습니다."
    }
  }
}

extension SearchServiceError.DecodeReason {
  var description: String {
    switch self {
    case .decodeFailure(let type):
      return "\(type) 디코딩에 실패했습니다."
    }
  }
}
