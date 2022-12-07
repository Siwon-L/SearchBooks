//
//  CallbackQueue.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

enum CallbackQueue {
  case mainAsync
  case mainCurrentOrAsync
  case untouch
  case dispatch(DispatchQueue)
  
  public func execute(_ block: @escaping () -> Void) {
    switch self {
    case .mainAsync:
      DispatchQueue.main.async { block() }
    case .mainCurrentOrAsync:
      DispatchQueue.main.safeAsync { block() }
    case .untouch:
      block()
    case .dispatch(let queue):
      queue.async { block() }
    }
  }
}

extension DispatchQueue {
  func safeAsync(_ block: @escaping () -> Void) {
      if self === DispatchQueue.main && Thread.isMainThread {
          block()
      } else {
          async { block() }
      }
  }
}
