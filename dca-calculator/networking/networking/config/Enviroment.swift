//
//  Enviroment.swift
//  networking
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import Foundation

public struct Enviroment {
    
   public static func configuration(_ key: Plist) -> String {
    let bundle = Bundle(for: Networking.self)
        if let path = bundle.path(forResource: "Info", ofType: "plist") {
            let nsDictionary = NSDictionary(contentsOfFile: path)
            switch key {
            case .baseUrl:
                return nsDictionary![Plist.baseUrl.value()] as? String ?? ""
            case .apiKey:
                return nsDictionary![Plist.apiKey.value()] as? String ?? ""
            }
        } else {
            fatalError("Unable to locate plist file")
        }
    }
}

public enum Plist {
    case baseUrl
    case apiKey
    
    func value() -> String {
        switch self {
        case .baseUrl:
            return "base_url"
        case .apiKey:
            return "api_key"
        }
    }
}


