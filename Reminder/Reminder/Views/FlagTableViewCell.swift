//
//  FlagTableViewCell.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 14.05.2021.
//

import UIKit

protocol FlagTableViewCellDelegate {
    func isSwitchChanged(switchValue: Bool)
}

class FlagTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "FlagTableViewCell"

    var delegate : FlagTableViewCellDelegate!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var flagBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        flagBackgroundView.layer.cornerRadius = 8
        
        switchOutlet.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func switchChanged() {
        delegate.isSwitchChanged(switchValue: switchOutlet.isOn)
    }
    
}


