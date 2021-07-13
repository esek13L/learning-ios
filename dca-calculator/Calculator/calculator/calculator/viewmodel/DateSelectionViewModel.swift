//
//  DateSelectionViewModel.swift
//  calculator
//
//  Created by Esekiel Surbakti on 22/06/21.
//

import Foundation
import Combine

class DateSelectionViewModel {
    
    @Published var monthInfos: [MonthInfo]?
    @Published var selectedIndex: Int?
}
