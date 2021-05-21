//
//  ListTableViewController.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 16.05.2021.
//

import UIKit

protocol ListTableViewControllerDelegate {
    func didUpdateReminders(reminders: [Remind])
}

class ListTableViewController: UITableViewController {
    
    var reminders = [Remind]()
    var currentList: List?
    var listArray = [String]()
    var flagArray = [Bool]()
    var priorityArray = [String]()
    var delegate: ListTableViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(UINib.loadNib(name: ListTableViewCell.reuseIdentifier), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        newReminderButtonSetup()
        configure()
    }
    
    private func configure() {

        let leftbutton = UIButton(type: .system)
        leftbutton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        leftbutton.setTitle("Back", for: .normal)
        leftbutton.sizeToFit()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: currentList!.color!)]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes as [NSAttributedString.Key : Any]
        leftbutton.addTarget(self, action: #selector(leftBarAction), for: .touchUpInside)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = currentList?.name
        navigationController?.navigationBar.tintColor = UIColor(hex: currentList!.color!)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
        
    }

    @objc func leftBarAction() {

        delegate.didUpdateReminders(reminders: reminders)
        dismiss(animated: true, completion: nil)
    }
    
    private func newReminderButtonSetup() {
        let newReminderButton = UIButton()

        newReminderButton.backgroundColor = .clear
        newReminderButton.tintColor = UIColor(hex: currentList!.color!)
        newReminderButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        newReminderButton.imageView?.layer.transform = CATransform3DMakeScale(1.6, 1.6, 1.6)
        newReminderButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        newReminderButton.setTitle("New Reminder", for: .normal)
        newReminderButton.setTitleColor(UIColor(hex: currentList!.color!), for: .normal)
        newReminderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        newReminderButton.addTarget(self, action: #selector(newReminderButtonAction), for: .touchUpInside)
        tableView.addSubview(newReminderButton)
        
        NSLayoutConstraint.activate([
            newReminderButton.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor,constant: 8),
            newReminderButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            newReminderButton.heightAnchor.constraint(equalToConstant: 40),
            newReminderButton.widthAnchor.constraint(equalToConstant: 180)
        ])
        newReminderButton.translatesAutoresizingMaskIntoConstraints = false

    }
    
    @objc func newReminderButtonAction() {
        fetchReminders()
        DispatchQueue.main.async {
            self.listArray.append(" ")
            self.flagArray.append(false)
            self.priorityArray.append("None")
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReminders()
    }
    
    private func fetchReminders() {
        reminders.removeAll()
        listArray.removeAll()
        flagArray.removeAll()
        priorityArray.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext

        do {
            let results = try context.fetch(Remind.fetchRequest()) as! [Remind]
            for result in results {
                if result.relation == currentList {
                    reminders.append(result)
                    listArray.append(result.title ?? "")
                    flagArray.append(result.flagged)
                    priorityArray.append(result.priority ?? "None")
                }
                
            }
        }
        
        catch {
            
        }
    }
    
    private func deleteFromCoreData(indexPath : IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        do {
            context.delete(reminders[indexPath.row])
            self.listArray.remove(at: indexPath.row)
            self.flagArray.remove(at: indexPath.row)
            self.priorityArray.remove(at: indexPath.row)
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    //MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteFromCoreData(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteFromCoreData(indexPath: indexPath)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
        cell.configure(title: listArray[indexPath.row], flagged: flagArray[indexPath.row], priority: priorityArray[indexPath.row])
        cell.currentList = currentList
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
    
}


