//
//  SearchServiceMock.swift
//  calculatorTests
//
//  Created by Esekiel Surbakti on 15/06/21.
//

import Foundation
import Combine
@testable import calculator
@testable import networking

struct SearchServiceMock: SearchServiceProtocol {
    
    var result: Result<SearchResults, APIError>
    
    func fetchSymbolPublisher(keyword: String) -> AnyPublisher<SearchResults, APIError> {
        result.publisher
            .eraseToAnyPublisher()
    }
    
    
//    func fetchSymbolPublisher(keyword: String) -> AnyPublisher<SearchResults, APIError> {
//        let data = SearchResults(items: [
//            SearchResult(symbol: "TESC.FRK", name: "TESC", type: "Equity", currency: "EUR"),
//            SearchResult(symbol: "TESHX", name: "TIAACREF SHORTTERM BOND INDEX FUND RETIREMENT CLASS", type: "Mutual Fund", currency: "USD"),
//            SearchResult(symbol: "TESHX", name: "TIAACREF SHORTTERM BOND INDEX FUND RETIREMENT CLASS", type: "Mutual Fund", currency: "USD")
//        ])
//        return Just(data)
//            .setFailureType(to: APIError.self)
//            .eraseToAnyPublisher()
//    }
    
    
}
