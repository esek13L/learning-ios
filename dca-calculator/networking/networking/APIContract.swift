//
//  ApiContract.swift
//  networking
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import Foundation


public struct APIContract {
    
    public static let BASE_URL = Enviroment.configuration(Plist.baseUrl).replacingOccurrences(of: "\\", with: "")
    public static let API_KEY = Enviroment.configuration(Plist.apiKey)
    public static let SYMBOL_SEARCH = "query?function=SYMBOL_SEARCH&keywords="
}
