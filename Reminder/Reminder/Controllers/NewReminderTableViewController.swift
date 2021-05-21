//
//  NewReminderTableViewController.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 14.05.2021.
//

import UIKit

class NewReminderTableViewController: UITableViewController, TextFieldTableViewCellDelegate, NotesTableViewCellDelegate, FlagTableViewCellDelegate {
    func isSwitchChanged(switchValue: Bool) {
        print("\(switchValue)")
            isFlagged = switchValue
    }
    
    func didUpdateTextField(text: String) {
        print("notes text \(text)")
        notesText = text
    }
    
    func printText(text: String) {
        print("title text: \(text)")
        titleText = text
    }
    
    let priorityArray = ["None","Low","Normal","High"]
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var priorityLabel = ""
    var currentLists = [List?]()
    var currentPicker : Int?
    var listLabel = ""
    var titleText : String?
    var notesText : String?
    var isFlagged = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(50)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib.loadNib(name: TextFieldTableViewCell.reuseIdentifier), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        tableView.register(UINib.loadNib(name: PickerTableViewCell.reuseIdentifier), forCellReuseIdentifier: PickerTableViewCell.reuseIdentifier)
        tableView.register(UINib.loadNib(name: FlagTableViewCell.reuseIdentifier), forCellReuseIdentifier: FlagTableViewCell.reuseIdentifier)
        tableView.register(UINib.loadNib(name: NotesTableViewCell.reuseIdentifier), forCellReuseIdentifier: NotesTableViewCell.reuseIdentifier)
        configure()
    }
    
    private func configure() {
      title = "New Reminder"
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(leftBarAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonAction))

        navigationItem.rightBarButtonItem?.isEnabled = true
        
        priorityLabel = priorityArray.first!
        listLabel = (currentLists[0]?.name)!
    }
    
    private func showPickerAsToolBar() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .systemBackground
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        
        self.view.addSubview(toolBar)
    }
    
    @objc func addButtonAction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let remind = Remind(context: context)
    
        for list in currentLists {
            if list?.name == listLabel {
                let tempList = list
                remind.flagged = isFlagged
                remind.notes = notesText
                remind.priority = priorityLabel
                remind.title = titleText
                remind.relation = tempList
                
                do {
                    try context.save()
                }
                catch {
                    
                }
            }
        }
        
            let vc = UINavigationController(rootViewController: ViewController())
            vc.modalPresentationStyle = .fullScreen
        
            self.navigationController?.present(vc,animated: false)
        
        
    }
    //MARK: Obj-C Functions
    
    @objc func leftBarAction() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onDoneButtonTapped() {
        
        if currentPicker == 3 {
            self.priorityLabel = priorityArray[picker.selectedRow(inComponent: 0)]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        if currentPicker == 1 {
            self.listLabel = (currentLists[picker.selectedRow(inComponent: 0)]?.name)!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
     
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    //MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath[0] == 0{
            
        }
        if indexPath[0] == 1 {
            currentPicker = 1
            
            showPickerAsToolBar()
        }
        
        if indexPath[0] == 3 {
            
            currentPicker = 3
            
            showPickerAsToolBar()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath[0] == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.delegate = self
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.reuseIdentifier, for: indexPath) as! NotesTableViewCell
                cell.delegate = self
                return cell
            }
           
        }
        
        if indexPath [0] == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.reuseIdentifier, for: indexPath) as! PickerTableViewCell
            cell.configure(name: "List", type: listLabel)
            return cell
        }
        
        if indexPath [0] == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FlagTableViewCell.reuseIdentifier, for: indexPath) as! FlagTableViewCell
            cell.delegate = self
            return cell
        }
        
        if indexPath [0] == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.reuseIdentifier, for: indexPath) as! PickerTableViewCell
            cell.configure(name: "Priority", type: priorityLabel)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = priorityArray[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath[0] == 0 && indexPath.row == 1 {
            return 120
        }
        else {
            return 50
        }
    }
}

extension NewReminderTableViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if currentPicker == 3 {
            return priorityArray[row]
        }
        
        if currentPicker == 1 {
            return currentLists[row]?.name
        }
        
        return ""
    }
}

extension NewReminderTableViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if currentPicker == 3 {
            return priorityArray.count
        }
        if currentPicker == 1 {
            return currentLists.count
        }
        
        return 1
    }
}
