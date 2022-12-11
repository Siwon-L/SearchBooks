//
//  FavoritesBookStorage.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/09.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

protocol FavoritesBookStoragable {
  var getValue: [String] { get }
  func addValue(_ isbn: String)
  func removeValue(_ isbn: String)
}

final class FavoritesBookStorage: FavoritesBookStoragable {
  private let memory: UserDefaults
  private let key: String
  
  init(memory: UserDefaults = .standard, key: String = "FavoritesBookIsbn") {
    self.memory = memory
    self.key = key
  }
  
  var getValue: [String] {
    return (memory.array(forKey: key) ?? []).compactMap { $0 as? String }
  }
  
  func addValue(_ isbn: String) {
    var values = (memory.array(forKey: key) ?? []).compactMap { $0 as? String }
    values.append(isbn)
    memory.set(values, forKey: key)
  }
  
  func removeValue(_ isbn: String) {
    var values = (memory.array(forKey: key) ?? []).compactMap { $0 as? String }
    values.removeAll { $0 == isbn }
    memory.set(values, forKey: key)
  }
}
