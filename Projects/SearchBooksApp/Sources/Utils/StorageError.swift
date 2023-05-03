//
//  StorageError.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2023/05/02.
//  Copyright © 2023 SearchBooks. All rights reserved.
//

import Foundation

enum StorageError: LocalizedError {
  case exceededNumberOfItems
  
  var errorDescription: String? {
    switch self {
    case .exceededNumberOfItems:
      return "즐겨찾기는\n10개까지만 가능합니다."
    }
  }
}
