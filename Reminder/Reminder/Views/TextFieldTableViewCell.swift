//
//  TextFieldTableViewCell.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 14.05.2021.
//

import UIKit
protocol TextFieldTableViewCellDelegate {
    func printText(text : String)
}

class TextFieldTableViewCell: UITableViewCell {
    
    var delegate : TextFieldTableViewCellDelegate!
    
    
    static let reuseIdentifier: String = "TextFieldTableViewCell"
    @IBOutlet weak var newReminderTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        newReminderTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
}

extension TextFieldTableViewCell : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate.printText(text: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newReminderTextField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }

}
