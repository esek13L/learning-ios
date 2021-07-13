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
    
    lazy var monthlyAdjustedMockData: MonthlyAdjusted = {
        let meta = Meta(symbol: "USD")
        let timeSeries: [String: OHLC] = [
            "2021-07-12" : OHLC(open: "36.0300", close: "32.8500", adjustedClosed: "35.6100"),
            "2021-06-30": OHLC(open: "31.8100", close: "36.1300", adjustedClosed: "36.1300")
            ]
        
        let data = MonthlyAdjusted(meta: meta, timeSeries: timeSeries)
        
        return data
    }()
    
    lazy var searchMockData: SearchResults = {
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
    func testRequestAPI() {
        let mock = SearchServiceMock(monthResult: .success(monthlyAdjustedMockData), result: .success(searchMockData))
        let viewModel = SearchViewModel(service: mock)
        
        let searchExpectation = self.expectation(description: "Loading search result")
        let monthExpectation = self.expectation(description: "Loading month result")
        
        viewModel.searchCompany(keywords: "anything")
        viewModel.fetchMonthlyAdjusted(symbol: "USD", searchResult: searchMockData.items[0])
        
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
                    searchExpectation.fulfill()
                }
            }).store(in: &subscriptions)
        
        viewModel.$asset
            .filter { asset in
                asset != nil
            }.sink { asset in
                guard let asset = asset else { return }
                XCTAssertEqual(asset.monthlyAdjusted.meta.symbol, "USD")
                if asset.monthlyAdjusted.timeSeries.count == 2 {
                    monthExpectation.fulfill()
                }
            }.store(in: &subscriptions)
        
        wait(for: [searchExpectation], timeout: 1)
        wait(for: [monthExpectation], timeout: 1)
    }
    
    func testRequestError() {
        let mock = SearchServiceMock(monthResult: .failure(APIError.error4xx(402)), result: .failure(APIError.error4xx(402)))
        let viewModel = SearchViewModel(service: mock)
        
        let monthExpectation = expectation(description: "should be second error")
        let searchExpectation = expectation(description: "should be error")
        viewModel.fetchMonthlyAdjusted(symbol: "USD", searchResult: searchMockData.items[0])
        viewModel.searchCompany(keywords: "anything")
        
        viewModel.$results.filter { results in
            results != nil
        }.sink { result in
            XCTFail("should be nil")
        }.store(in: &subscriptions)
        
        viewModel.$asset.filter { asset in
            asset != nil
        }.sink { asset in
            XCTFail("should be nil")
        }.store(in: &subscriptions)
        
        viewModel.$requestError.filter { requestError in
            requestError != nil
        }.sink { value in
            guard let error = value else { return }
            if error.errorCode == String(402) && error.errorDescription == "Error 4xx" {
                searchExpectation.fulfill()
                monthExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [searchExpectation], timeout: 1)
        wait(for: [monthExpectation], timeout: 1)
    }
    
    func testLoadingShouldNotRunningAfterRequest() {
        let mock = SearchServiceMock(monthResult: .success(monthlyAdjustedMockData), result: .success(searchMockData))
        let viewModel = SearchViewModel(service: mock)
        
        viewModel.searchCompany(keywords: "anything")
        
        viewModel.$isLoading.filter { isLoading in
            isLoading == true
        }.sink { value in
            XCTFail("loading should not running")
        }.store(in: &subscriptions)
    }
    
    
}
