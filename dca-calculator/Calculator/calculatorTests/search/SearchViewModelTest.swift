//
//  SearchViewModelTest.swift
//  calculatorTests
//
//  Created by Esekiel Surbakti on 15/06/21.
//

import XCTest
@testable import calculator
@testable import networking
import Combine

class SearchViewModelTest: XCTestCase {
    
    lazy var mockData: SearchResults = {
        let data = SearchResults(items: [
            SearchResult(symbol: "TESC.FRK", name: "TESC", type: "Equity", currency: "EUR"),
            SearchResult(symbol: "TESA12.SAO", name: "TESA12", type: "Equity", currency: "BRL"),
            SearchResult(symbol: "TESD.FRK", name: "TESD", type: "Equity", currency: "EUR")
        ])
        return data
    }()
    
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
    
    //testing async function with expectation()
    func testFetchSymbolPublisher() {
        let mock = SearchServiceMock(result: .success(mockData))
        let viewModel = SearchViewModel(service: mock)
        
        let expectation = self.expectation(description: "Loading search result")
        
        viewModel.searchCompany(keywords: "anything")
        
        viewModel.$results
            .filter({ results in
                results != nil
            })
            .sink(receiveValue: { result in
                guard let results = result?.items else { return }
                XCTAssertEqual(results[0].symbol, "TESC.FRK")
                XCTAssertEqual(results[1].symbol, "TESA12.SAO")
                XCTAssertEqual(results[2].symbol, "TESD.FRK")
                if results.count == 3{
                    expectation.fulfill()
                }
            }).store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestError() {
        let mock = SearchServiceMock(result: .failure(APIError.error4xx(402)))
        let viewModel = SearchViewModel(service: mock)
        
        viewModel.searchCompany(keywords: "anything")
        
        viewModel.$results.filter { results in
            results != nil
        }.sink { result in
            XCTFail("should be nil")
        }.store(in: &subscriptions)
        
        let expectation = expectation(description: "should be error")
        
        viewModel.$requestError.filter { requestError in
            requestError != nil
        }.sink { value in
            guard let error = value else { return }
            if error.errorCode == String(402) && error.errorDescription == "Error 4xx" {
                expectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadingShouldNotRunningAfterRequest() {
        let mock = SearchServiceMock(result: .success(mockData))
        let viewModel = SearchViewModel(service: mock)
        
        viewModel.searchCompany(keywords: "anything")
        
        viewModel.$isLoading.filter { isLoading in
            isLoading == true
        }.sink { value in
            XCTFail("loading should not running")
        }.store(in: &subscriptions)
    }
    
    
}
