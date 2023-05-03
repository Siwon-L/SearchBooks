//
//  FavoritesBookStorage.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/09.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

protocol FavoritesBookStoragable {
  var getValue: Set<String> { get }
  func addValue(_ isbn: String) throws
  func removeValue(_ isbn: String)
}

final class FavoritesBookStorage: FavoritesBookStoragable {
  private let memory: UserDefaults
  private let key: String
  
  init(memory: UserDefaults = .standard, key: String = "FavoritesBookIsbn") {
    self.memory = memory
    self.key = key
  }
  
  var getValue: Set<String> {
    let value = (memory.array(forKey: key) ?? []).compactMap { $0 as? String }
    return Set(value)
  }
  
  func addValue(_ isbn: String) throws {
    var values = (memory.array(forKey: key) ?? []).compactMap { $0 as? String }
    if values.count >= 10 {
      throw StorageError.exceededNumberOfItems
    }
    values.append(isbn)
    memory.set(values, forKey: key)
  }
  
  func removeValue(_ isbn: String) {
    var values = (memory.array(forKey: key) ?? []).compactMap { $0 as? String }
    values.removeAll { $0 == isbn }
    memory.set(values, forKey: key)
  }
}
