//
//  CalculatorViewModel.swift
//  calculator
//
//  Created by Esekiel Surbakti on 16/06/21.
//

import Foundation
import Combine

class CalculatorViewModel {
    private var service: CalculatorServiceProtocol
    
    @Published var asset: Asset?
    @Published var selectedDateIndex: Int?
    @Published var initialInvestmentAmount: Int?
    @Published var monthlyDollarCostAmount: Int?
    var subscribers = Set<AnyCancellable>()
    
    init(service: CalculatorServiceProtocol = CalculatorService()) {
        self.service = service
    }
    
    func calculate(asset: Asset, initialInvestmentAmount: Double,
                   monthlyDollarCostAveragingAmount: Double, initialDateOfInvestmentIndex: Int) -> DCAResult {
        
        return service.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
    }
    
    func getPresentation(result: DCAResult) -> CalculatorPresentation {
        
        let isProfitable = result.isProfitable == true
        let gainSymbol = isProfitable ? "+" : ""
        
        return .init(currentValueLabelBackgroundColor: isProfitable ? .themeGreenShade : .themeRedShade,
                     currentValue: result.currentValue.currencyFormat,
                     investmentAmount: result.investmentAmount.toCurrencyFormat(hasDecimalPlaces: false),
                     gain: result.gain.toCurrencyFormat(hasDollarSymbol: true, hasDecimalPlaces: false).prefix(withText: gainSymbol),
                     yield: result.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets(),
                     yieldLabelTextColor: isProfitable ? .systemGreen : .systemRed,
                     annualReturn: result.annualReturn.percentageFormat,
                     annualReturnLabelTextColor: isProfitable ? .systemGreen : .systemRed)
    }
}
