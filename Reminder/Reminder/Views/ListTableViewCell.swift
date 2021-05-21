//
//  ListTableViewCell.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 16.05.2021.
//

import UIKit
import Combine

class ListTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "ListTableViewCell"
    @Published var name = ""
    let myString = "!"
    let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    @IBOutlet weak var flagIconView: UIImageView!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var listTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentList: List?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionImageView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        listTextField.delegate = self
        //listTextField.becomeFirstResponder()
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            selectionImageView.image = UIImage(systemName: "largecircle.fill.circle")
        }
       
    }
    
    func addReminderToTheList() {
        print("CurrentList \(String(describing: currentList!.name)) ")
        let context = appDelegate.persistentContainer.viewContext
        let reminder = Remind(context: context)
        reminder.relation = currentList
        reminder.title = name
        reminder.flagged = false
        reminder.notes = ""
        reminder.priority = "None"
        
        do {
            
            try context.save()
            print("saved")
        }
        catch {
            
        }
       
        print(name)
    }
    
    func configure(title: String, flagged: Bool, priority: String) {
        
        if !flagged {
            flagIconView.isHidden = true
        }
        
        
        
        switch priority {
        case "None":
            listTextField.text = title
        case "Low":
            let myAttrString = NSMutableAttributedString(string: myString, attributes: myAttribute)
            listTextField.text = myAttrString.string + " " + title
        case "Normal":
            let myAttrString = NSMutableAttributedString(string: myString + myString, attributes: myAttribute)
            listTextField.text = myAttrString.string + " " + title
        default:
            let myAttrString = NSMutableAttributedString(string: myString + myString + myString, attributes: myAttribute)
            listTextField.text =  myAttrString.string + " " + title
        }
        
    }

    
    
}

extension ListTableViewCell : UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        name = textField.text!
        
        addReminderToTheList()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == listTextField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
