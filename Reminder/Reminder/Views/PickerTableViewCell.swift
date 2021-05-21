//
//  PickerTableViewCell.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 14.05.2021.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    static let reuseIdentifier: String = "PickerTableViewCell"
    @IBOutlet weak var listTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure (name: String,type: String) {
        nameLabel.text = name
        listTypeLabel.text = type
        
        
        
    }
    
}
