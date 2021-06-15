//
//  SearchViewModel.swift
//  calculator
//
//  Created by Esekiel Surbakti on 10/06/21.
//

import Foundation
import Combine
import networking

enum Mode {
    case onboarding
    case searching
}

class SearchViewModel {
    
    var service: SearchService
    
    @Published var changeMe: String = ""
    @Published var results: SearchResults?
    @Published var requestError: RequestError?
    @Published var searchQuery: String?
    @Published var mode: Mode = Mode.onboarding
    @Published var isLoading = false
    
    var result: SearchResult?
    
    var subscribers = Set<AnyCancellable>()
    
    init(service: SearchService) {
        self.service = service
    }
    
    func searchCompany(keywords: String) {
        service.fetchSymbolPublisher(keyword: keywords).sink { receiveCompletion in
            switch receiveCompletion {
            case .failure(let error):
                self.requestError = error.value()
            case .finished:
                break
            }
        } receiveValue: { results in
            self.results = results
        }.store(in: &subscribers)
        
        
    }
}
