//
//  DateSelectionCell.swift
//  calculator
//
//  Created by Esekiel Surbakti on 17/06/21.
//

import UIKit
import core

class DateSelectionCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helpers
    
    func configure(with monthInfo: MonthInfo, index: Int, isSelected: Bool) {
        monthLabel.text = monthInfo.date.MMYYFormat
        accessoryType = isSelected ? .checkmark : .none
        if index == 1 {
            monthAgoLabel.text = "1 month ago"
        } else if index > 1 {
            monthAgoLabel.text = "\(index) months ago"
        } else {
            monthAgoLabel.text = "Just invested"
        }
    }
    
    
}
