//
//  String.swift
//  core
//
//  Created by Esekiel Surbakti on 16/06/21.
//

import Foundation

public extension String {
    
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
}
