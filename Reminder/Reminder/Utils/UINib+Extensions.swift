//
//  UINib+Extensions.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 12.05.2021.
//

import Foundation
import UIKit

extension UINib {
    static func loadNib(name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
}

extension UIView {
    func loadNib(name: String) -> UIView {
        if let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as? UIView {
            return view
        }
        return UIView()
    }
}
