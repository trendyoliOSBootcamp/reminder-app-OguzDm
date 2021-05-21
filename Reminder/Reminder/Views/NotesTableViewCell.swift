//
//  NotesTableViewCell.swift
//  Reminder
//
//  Created by Oguz Demırhan on 19.05.2021.
//

import UIKit

protocol NotesTableViewCellDelegate {
    func didUpdateTextField(text: String)
}

class NotesTableViewCell: UITableViewCell {
    
    var delegate : NotesTableViewCellDelegate!
    static let reuseIdentifier = "NotesTableViewCell"

    @IBOutlet weak var notesTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        notesTextField.delegate = self
    }
    
}

extension NotesTableViewCell : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate.didUpdateTextField(text: textField.text!)
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == notesTextField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }

}
