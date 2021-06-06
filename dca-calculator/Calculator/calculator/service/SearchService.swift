//
//  SearchService.swift
//  calculator
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import Combine
import networking

struct SearchService {
    
    private let apiKey = APIContract.API_KEY
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        let pathUrl = APIContract.BASE_URL + APIContract.SYMBOL_SEARCH
        let urlString = "\(pathUrl)\(keywords)&apikey=\(apiKey)"
        print(urlString)
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
