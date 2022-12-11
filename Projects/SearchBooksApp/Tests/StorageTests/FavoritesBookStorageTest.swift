//
//  FavoritesBookStorageTest.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2022/12/10.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import XCTest
@testable import SearchBooksApp

import RxSwift

final class FavoritesBookStorageTest: XCTestCase {
  private var sut: FavoritesBookStoragable!
  private var userDefaults: UserDefaults!
  
  override func setUpWithError() throws {
    userDefaults = .init(suiteName: "test")
    sut = FavoritesBookStorage(memory: userDefaults, key: "test")
  }
  
  override func tearDownWithError() throws {
    userDefaults.removeObject(forKey: "test")
    userDefaults = nil
    sut = nil
  }
  
  func test_addValue메서드를_호출하면_파라미터_값이_UserDefaults에_저장되어야한다() {
    // given
    sut.addValue("123")
    
    // when
    let value = sut.getValue
    
    // then
    XCTAssertEqual(["123"], value)
  }
  
  func test_removeValue메서드를_호출하면_파라미터_값이_UserDefaults에서_제거되어야한다() {
    // given
    sut.addValue("123")
    sut.removeValue("123")
    
    // when
    let value = sut.getValue
    
    // then
    XCTAssertTrue(value.isEmpty)
  }
}
