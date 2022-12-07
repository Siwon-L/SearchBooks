//
//  HTTPError.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

enum HTTPError: LocalizedError {
  case createURLError

  var errorDescription: String? {
    switch self {
    case .createURLError:
      return "URL 생성에 실패했습니다."
    }
  }
}
