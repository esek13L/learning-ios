//
//  SearchResults.swift
//  calculator
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import Foundation


struct SearchResults: Codable {
    var items: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case items = "bestMatches"
    }
}

struct SearchResult: Codable {
    let symbol: String
    let name: String
    let type: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
    
}

