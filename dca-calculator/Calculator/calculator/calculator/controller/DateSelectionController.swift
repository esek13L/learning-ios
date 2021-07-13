//
//  DateSelectionController.swift
//  calculator
//
//  Created by Esekiel Surbakti on 17/06/21.
//

import UIKit

protocol DateSelectionDelegate {
    func selectDate(index: Int)
}

class DateSelectionController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var viewModel: DateSelectionViewModel!
    var delegate: DateSelectionDelegate?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Helpers
    
    private func setupView() {
        navigationItem.title = "Select date"
        tableView.register(UINib(nibName: "DateSelectionCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "DateCell")
        tableView.dataSource = self
        tableView.delegate = self
     
    }
    
}

//MARK: - UITableViewDataSource

extension DateSelectionController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.monthInfos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateSelectionCell
        if let monthInfos = viewModel.monthInfos {
            let index = indexPath.item
            let isSelected = index == viewModel.selectedIndex
            cell.configure(with: monthInfos[index], index: index, isSelected: isSelected)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate

extension DateSelectionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectDate(index: indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}
