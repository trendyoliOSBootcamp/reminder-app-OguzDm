//
//  ReminderTypeCollectionViewCell.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 12.05.2021.
//

import UIKit

class ReminderTypeCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ReminderTypeCollectionViewCell"
    @IBOutlet weak var typeImageBackground: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeCountLabel: UILabel!
    @IBOutlet weak var ReminderTypeCellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ReminderTypeCellBackground.layer.cornerRadius = 24
    }
    
    func configure(type: String, count: String) {
       
        typeImageBackground.layer.cornerRadius = typeImageBackground.frame.height / 2
        typeImageView.tintColor = .white
        switch type {
        case "All":
            typeImageView.image = UIImage(systemName: "tray.fill")
            typeImageBackground.backgroundColor = .gray
        default:
            typeImageView.image = UIImage(systemName: "flag.fill")
            typeImageBackground.backgroundColor = .orange
        }
        
        typeLabel.text = type
        typeCountLabel.text = count
        
    }

}
