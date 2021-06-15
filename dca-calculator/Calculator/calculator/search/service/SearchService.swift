//
//  SearchService.swift
//  calculator
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import Combine
import networking

struct SearchService {
    
    private let apiClient = APIClient.instance
    
    private let apiKey = APIContract.API_KEY
    
    func fetchSymbolPublisher(keyword: String) -> AnyPublisher<SearchResults, APIError> {
        return apiClient.requestHttp(path: "\(APIContract.SYMBOL_SEARCH)\(keyword)&apikey=\(apiKey)", method: .get)
    }
    
    
}
