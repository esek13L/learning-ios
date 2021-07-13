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
    
    var monthResult: Result<MonthlyAdjusted, APIError>
    
    func fetchMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher<MonthlyAdjusted, APIError> {
        monthResult.publisher
            .eraseToAnyPublisher()
    }
    
    
    var result: Result<SearchResults, APIError>
    
    func fetchSymbolPublisher(keywords keyword: String) -> AnyPublisher<SearchResults, APIError> {
        result.publisher
            .eraseToAnyPublisher()
    }
}
