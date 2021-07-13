//
//  CalculatorController.swift
//  calculator
//
//  Created by Esekiel Surbakti on 16/06/21.
//

import UIKit
import Combine

class CalculatorController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var investmentView: InvestmentView!
    var viewModel: CalculatorViewModel?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        observeForm()
        
    }
    
    
    //MARK: - Helper
    
    private func setupViewModel() {
        if viewModel == nil {
            viewModel = CalculatorViewModel()
        }
    }
    
    private func setupView(asset: Asset) {
        navigationItem.title = asset.searchResult.symbol
        investmentView.configureUI(with: asset)
        investmentView.delegate = self
        investmentView.initialDateOfInvestmentTextField.delegate = self
    }
    
    private func setupDateSlider(count: Int) {
        investmentView.setDateSliderMaxValue(count: count)
    
    }
    
    private func setDateValue(index: Int) {
        if let monthInfos = viewModel?.asset?.monthlyAdjusted.getMonthInfos() {
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            investmentView.setDateValue(date: dateString)
        }
    }
    
    //MARK: - Service
    
    private func observeForm() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.$asset
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] asset in
                guard let asset = asset else { return }
                setupView(asset: asset)
                setupDateSlider(count: asset.monthlyAdjusted.getMonthInfos().count - 1)
            }.store(in: &viewModel.subscribers)
        
        viewModel.$selectedDateIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let index = index else { return }
                self?.investmentView.dateSlider.value = index.floatValue
                self?.setDateValue(index: index )
            }.store(in: &viewModel.subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: investmentView.initialInvestmentAmountTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { (text) in
            viewModel.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &viewModel.subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: investmentView.monthlyDollarCostAveragingTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { text in
            viewModel.monthlyDollarCostAmount = Int(text) ?? 0
        }.store(in: &viewModel.subscribers)
        
        // observe if value changed
        Publishers.CombineLatest3(viewModel.$initialInvestmentAmount, viewModel.$monthlyDollarCostAmount, viewModel.$selectedDateIndex)
            .sink { [weak self] (investmentAmount, monthlyDollarAmount, dateIndex) in
                guard let asset = viewModel.asset,
                      let investmentAmount = investmentAmount,
                      let monthlyDollarAmount = monthlyDollarAmount,
                      let dateIndex = dateIndex else { return }
                
                let result = viewModel.calculate(asset: asset, initialInvestmentAmount: investmentAmount.doubleValue, monthlyDollarCostAveragingAmount: monthlyDollarAmount.doubleValue, initialDateOfInvestmentIndex: dateIndex)
                
                self?.investmentView.setDcaResult(presentation: viewModel.getPresentation(result: result))
            }.store(in: &viewModel.subscribers)

    }
    
}

//MARK: - UITextFieldDelegate
extension CalculatorController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == investmentView.initialDateOfInvestmentTextField {
            
            let controller = DateSelectionController(nibName: "DateSelectionController", bundle: Bundle(for: type(of: self)))
            let dateViewModel = DateSelectionViewModel()
            if let asset = viewModel?.asset {
                dateViewModel.monthInfos = asset.monthlyAdjusted.getMonthInfos()
                dateViewModel.selectedIndex = viewModel?.selectedDateIndex
                controller.delegate = self
                controller.viewModel =  dateViewModel
                navigationController?.pushViewController(controller, animated: true)
                return false
            }
        }
        return true
    }
}

//MARK: - DateSelectionDelegate

extension CalculatorController: DateSelectionDelegate {
    func selectDate(index: Int) {
        viewModel?.selectedDateIndex = index
    }
}

//MARK: - InvestmentDelegate

extension CalculatorController: InvestmentDelegate {
    func onSliderChanged(index: Int) {
        viewModel?.selectedDateIndex = index
    }
    
    
}

