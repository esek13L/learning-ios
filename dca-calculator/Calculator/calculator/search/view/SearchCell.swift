//
//  SearchCell.swift
//  calculator
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import UIKit

class SearchCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var viewModel: SearchViewModel? {
        didSet {configureUI()}
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        guard let result = viewModel?.result else {
            return
        }
        nameLabel.numberOfLines = 4
        nameLabel.text = result.name
        symbolLabel.text = result.symbol
        typeLabel.text = result.type
            .appending(" ")
            .appending(result.currency)
    }
    
    
}
