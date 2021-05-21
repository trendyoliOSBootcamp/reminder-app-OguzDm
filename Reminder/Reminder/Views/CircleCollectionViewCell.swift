//
//  CircleCollectionViewCell.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 15.05.2021.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CircleCollectionViewCell"
    

    @IBOutlet weak var circleCellBackground: UIView!
    @IBOutlet weak var circleCellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        circleCellBackground.layer.cornerRadius = circleCellBackground.frame.width / 2
        
    }
    
    

}
