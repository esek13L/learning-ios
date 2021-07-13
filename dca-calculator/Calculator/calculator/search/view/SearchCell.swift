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
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI(with result: SearchResult) {
        nameLabel.numberOfLines = 4
        nameLabel.text = result.name
        symbolLabel.text = result.symbol
        typeLabel.text = result.type
            .appending(" ")
            .appending(result.currency)
    }
    
    
}
