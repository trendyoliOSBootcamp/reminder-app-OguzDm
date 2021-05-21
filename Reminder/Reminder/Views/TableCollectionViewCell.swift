//
//  TableCollectionViewCell.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 14.05.2021.
//

import UIKit

class TableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var reminderTypeIcon: UIImageView!
    @IBOutlet weak var reminderBackgroundView: UIView!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var reminderCountLabel: UILabel!
    
    static let reuseIdentifier: String = "TableCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.width / 2
        reminderTypeIcon.tintColor = .white
        reminderBackgroundView.backgroundColor = .secondarySystemBackground
    }
    
    func configure(name: String,systemName: String, hex: String, count: Int) {
       
        
        reminderTypeIcon.image = UIImage(systemName: systemName)
        listNameLabel.text = name
        iconBackgroundView.backgroundColor = UIColor(hex: hex)
        reminderCountLabel.text = String(count)
        
    }

}
