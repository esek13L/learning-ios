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
    
    var service: SearchServiceProtocol
    
    @Published var changeMe: String = ""
    @Published var results: SearchResults?
    @Published var requestError: RequestError?
    @Published var searchQuery: String?
    @Published var mode: Mode = Mode.onboarding
    @Published var isLoading = false
    @Published var asset: Asset?
    
    var subscribers = Set<AnyCancellable>()
    
    init(service: SearchServiceProtocol = SearchService()) {
        self.service = service
    }
    
    func searchCompany(keywords: String) {
        isLoading = true
        service.fetchSymbolPublisher(keywords: keywords).sink { [unowned self] receiveCompletion in
            switch receiveCompletion {
            case .failure(let error):
                isLoading = false
                self.requestError = error.value()
            case .finished:
                isLoading = false
                break
            }
        } receiveValue: { results in
            self.results = results
        }.store(in: &subscribers)
    }
    
    func fetchMonthlyAdjusted(symbol: String, searchResult: SearchResult) {
        isLoading = true
        service.fetchMonthlyAdjustedPublisher(keywords: symbol).sink { [unowned self] completion in
            switch completion {
            case .failure(let error):
                isLoading = false
                self.requestError = error.value()
            case .finished:
                isLoading = false
                break
            }
        } receiveValue: { monthlyAdjusted in
            let asset = Asset(searchResult: searchResult, monthlyAdjusted: monthlyAdjusted)
            self.asset = asset
            
        }.store(in: &subscribers)
        
    }
}
