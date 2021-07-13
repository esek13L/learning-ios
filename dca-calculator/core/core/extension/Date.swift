//
//  Date.swift
//  core
//
//  Created by Esekiel Surbakti on 22/06/21.
//

import Foundation

public extension Date {
    
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
