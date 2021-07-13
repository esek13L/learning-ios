//
//  InvestmentView.swift
//  calculator
//
//  Created by Esekiel Surbakti on 16/06/21.
//

import UIKit

protocol InvestmentDelegate {
    func onSliderChanged(index: Int)
}

class InvestmentView: UIView {
    
    //MARK: - Properties
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investmentAmountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var dateSlider: UISlider!
    var delegate: InvestmentDelegate?

    
    //MARK: - Lifecycle
    
    //used when view is created by nib/storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    //used when view is created by programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    //MARK: - Helpers
    
    private func initView() {
        Bundle(for: type(of: self)).loadNibNamed("InvestmentView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        resetView()
    }
    
    private func resetView() {
        currentValueLabel.text = "0.00"
        investmentAmountLabel.text = "0.00"
        gainLabel.text = "-"
        yieldLabel.text = "-"
        annualReturnLabel.text = "-"
    }
    
    func configureUI(with asset: Asset) {
        symbolLabel.text = asset.searchResult.symbol
        nameLabel.text = asset.searchResult.name
        investmentAmountCurrencyLabel.text = asset.searchResult.currency
        currencyLabels.forEach { label in
            label.text = asset.searchResult.currency.addBrackets()
        }
        setupTextField()
    }
    
    func setDateValue(date: String) {
        initialDateOfInvestmentTextField.text = date
    }
    
    func setDateSliderMaxValue(count: Int) {
        dateSlider.maximumValue = count.floatValue
    }
    
    private func setupTextField() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
    }
    
    func setDcaResult(presentation: CalculatorPresentation ) {
        currentValueLabel.backgroundColor = presentation.currentValueLabelBackgroundColor
        currentValueLabel.text = presentation.currentValue
        investmentAmountLabel.text = presentation.investmentAmount
        gainLabel.text = presentation.gain
        yieldLabel.text = presentation.yield
        yieldLabel.textColor = presentation.yieldLabelTextColor
        annualReturnLabel.text = presentation.annualReturn
        annualReturnLabel.textColor = presentation.annualReturnLabelTextColor    }
    
    //MARK: - Actions
    
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        delegate?.onSliderChanged(index: Int(sender.value))
    }
    
}
