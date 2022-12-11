//
//  NetworkServiceTest.swift
//  SearchBooksAppTests
//
//  Created by 이시원 on 2022/12/07.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import XCTest
@testable import SearchBooksApp

import RxSwift

final class NetworkServiceTest: XCTestCase {
  private var sut: NetworkService!
  private var disposeBag: DisposeBag!
  
  override func setUpWithError() throws {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [StubURLProtocol.self]
    let urlSession = URLSession(configuration: configuration)
    sut = NetworkService(urlSession: urlSession)
    disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    disposeBag = nil
  }
  
  func test_testRequest를_호출했을때_200이면_성공해야한다() {
    // given
    let expectation = XCTestExpectation()
    let sampleData = Data()
    
    StubURLProtocol.requestHandler = { _ in
      let data = sampleData
      let response = HTTPURLResponse(
        url: URL(string: "https://openapi.naver.com")!,
        statusCode: 200,
        httpVersion: "1.1",
        headerFields: nil
      )!
      return (data, response)
    }
    let endpoint = BooksEndpointAPI.searchBooks(
      query: "책",
      display: 10,
      start: 1,
      sort: .sim
    ).asEndpoint
    
    // when
    sut.request(endpoint: endpoint)
      .subscribe { data in
        // then
        XCTAssertEqual(data, sampleData)
        expectation.fulfill()
      } onError: { error in
        XCTFail(error.localizedDescription)
      }.disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 5.0)
  }
  
  func testRequest를_호출했을때_200이_아니면_실패해야한다() {
    // given
    let expectation = XCTestExpectation()

    StubURLProtocol.requestHandler = { request in
      let data = Data()
      let response = HTTPURLResponse(
        url: URL(string: "https://openapi.naver.com")!,
        statusCode: 400,
        httpVersion: "1.1",
        headerFields: nil
      )!
      return (data, response)
    }

    // when
    let endpoint = BooksEndpointAPI.searchBooks(
      query: "책",
      display: 10,
      start: 1,
      sort: .sim
    ).asEndpoint

    sut.request(endpoint: endpoint)
      .subscribe(onNext: { _ in
        XCTFail()
      }, onError: { error in
        // then
        let error = error as! SearchServiceError
        XCTAssertEqual(error.failureReason, "서비스 이용에 불편을 드려 죄송합니다. 잠시 후 다시 시도해주세요.")
        expectation.fulfill()
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 5.0)
  }
}
