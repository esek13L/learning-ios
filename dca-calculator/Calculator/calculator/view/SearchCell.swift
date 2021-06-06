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
    
    func configure(with searchResult: SearchResult)  {
        nameLabel.numberOfLines = 4
        nameLabel.text = searchResult.name
        symbolLabel.text = searchResult.symbol
        typeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }
    
    
}
