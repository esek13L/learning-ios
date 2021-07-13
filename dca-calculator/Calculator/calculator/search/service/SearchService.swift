//
//  SearchService.swift
//  calculator
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import Combine
import networking

protocol SearchServiceProtocol {
    func fetchSymbolPublisher(keywords: String) -> AnyPublisher<SearchResults, APIError>
    func fetchMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher<MonthlyAdjusted, APIError>
}

struct SearchService: SearchServiceProtocol {
    
    private let apiClient = APIClient.instance
    
    private let apiKey = APIContract.API_KEY
    
    func fetchSymbolPublisher(keywords: String) -> AnyPublisher<SearchResults, APIError> {
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIError.badRequest(400)).eraseToAnyPublisher()
        }
        return apiClient.requestHttp(path: "\(APIContract.SYMBOL_SEARCH)\(keywords)&apikey=\(apiKey)", method: .get)
    }
    
    func fetchMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher<MonthlyAdjusted, APIError> {
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIError.badRequest(400)).eraseToAnyPublisher()
        }
        return apiClient.requestHttp(path: "\(APIContract.MONTHLY_ADJUSTED_SEARCH)\(keywords)&apikey=\(apiKey)", method: .get)
    }
    
    
    
}
