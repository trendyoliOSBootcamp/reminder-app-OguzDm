//
//  ViewController.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 12.05.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, ListTableViewControllerDelegate {
    
    func didUpdateReminders(reminders: [Remind]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let lists = try context.fetch(List.fetchRequest()) as! [List]
            
            for list in lists {
                
            
                for reminder in reminders {
                    
                    if reminder.relation == list {
                    
                        list.count = Int16(reminders.count)
                        break
                    }
                }
            }
            try context.save()
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
            }
            
        }
        catch {
            
        }
        
    }
    
    var collectionView: UICollectionView!
    var tableView : UITableView!
    let searchBar = UISearchBar()
    var lists = [List]()
    var allCount = 0
    var reminders = [Remind]()
    var filteredReminders = [Remind]()
    var isFiltering = false
    var flaggedCount = 0
    //MARK: gridThenList
    
    let gridThenList = UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in

        if section == 0 {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.3))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5)
            
            return section
            
            
        } else {
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            let section = NSCollectionLayoutSection.list(using: UICollectionLayoutListConfiguration(appearance: .insetGrouped), layoutEnvironment: env)
            section.boundarySupplementaryItems = [headerElement]
            return section
        }
    }

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let vc = ListTableViewController()
        vc.delegate = self
        searchBar.delegate = self
        print("Application directory: \(NSHomeDirectory())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("view will appear")
        getLists()
        fetchReminders()
        calculate()
        
    }
    
    
    
    //MARK: getList
    
    private func getLists() {
        
        lists.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let results = try context.fetch(List.fetchRequest()) as! [List]
            if results.count > 0 {
                
                for result in results  {
                    
                    lists.append(result)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
        
        catch {
            print("Error")
        }
    }
    
    //MARK: Calculate
    
    private func calculate() {
        DispatchQueue.main.async {
            var sum = 0
            var flaggedSum = 0
            
            for list in self.lists {
                
                sum += Int(list.relation?.count ?? 0)
                
            }
            
            for remind in self.reminders {
                
                if remind.flagged {
                    flaggedSum += 1
                }
            }
            
            self.allCount = sum
            self.flaggedCount = flaggedSum
            self.collectionView.reloadData()
        }
    }
    
    //MARK: TableView Configure
    private func tableViewConfigure() {
        fetchReminders()
        tableView = UITableView(frame: view.bounds, style: .plain)
        //tableView.sectionHeaderHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.loadNib(name: ListTableViewCell.reuseIdentifier), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        searchBar.setShowsCancelButton(true, animated: true)
        view.addSubview(tableView)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
      
    }
    
    private func filterContextForSearchText(searchText: String) {
        filteredReminders = reminders.filter({ (user:Remind) -> Bool in
            return user.title!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    private func fetchReminders() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        do {
            let results = try context.fetch(Remind.fetchRequest()) as! [Remind]
            reminders = results

        }
        catch {
            
        }
    }
    
    //MARK: newReminderButtonSetup
    
    private func newReminderButtonSetup() {
        let newReminderButton = UIButton()

        newReminderButton.backgroundColor = .clear
        newReminderButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        newReminderButton.imageView?.layer.transform = CATransform3DMakeScale(1.6, 1.6, 1.6)
        newReminderButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        newReminderButton.setTitle("New Reminder", for: .normal)
        newReminderButton.setTitleColor(UIColor.link, for: .normal)
        newReminderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        newReminderButton.addTarget(self, action: #selector(newReminderButtonAction), for: .touchUpInside)
        collectionView.addSubview(newReminderButton)
        
        
        NSLayoutConstraint.activate([
            newReminderButton.leftAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.leftAnchor,constant: 8),
            newReminderButton.bottomAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            newReminderButton.heightAnchor.constraint(equalToConstant: 40),
            newReminderButton.widthAnchor.constraint(equalToConstant: 180)
        ])
        newReminderButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func newReminderButtonAction() {
        let vc = NewReminderTableViewController()
        vc.currentLists = lists
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.present(nav,animated: true)
    }
    
    //MARK: addListButtonSetup
    
    private func addListButtonSetup() {
        let addListButton = UIButton()

        addListButton.backgroundColor = .clear
        addListButton.setTitle("Add List", for: .normal)
        addListButton.setTitleColor(UIColor.link, for: .normal)
        addListButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        addListButton.addTarget(self, action: #selector(addListButtonAction), for: .touchUpInside)
        collectionView.addSubview(addListButton)
        
        
        NSLayoutConstraint.activate([
            addListButton.rightAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.rightAnchor,constant: -8),
            addListButton.bottomAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            addListButton.heightAnchor.constraint(equalToConstant: 40),
            addListButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        addListButton.translatesAutoresizingMaskIntoConstraints = false

    }
    
    @objc func addListButtonAction() {
        
        let vc = UINavigationController(rootViewController: AddListViewController())
        
        navigationController?.present(vc,animated: true)
    }
    
    //MARK: general configure
    private func configure() {
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: gridThenList)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UINib.loadNib(name: ReminderTypeCollectionViewCell.reuseIdentifier), forCellWithReuseIdentifier: ReminderTypeCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib.loadNib(name: TableCollectionViewCell.reuseIdentifier ), forCellWithReuseIdentifier: TableCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor =
            UIColor { traitCollection in
                
                switch traitCollection.userInterfaceStyle {
                case .dark:
                  
                    return UIColor.black
                default:
                  
                    return UIColor.secondarySystemBackground
                }
              }
        
        
        view.addSubview(collectionView)
        newReminderButtonSetup()
        addListButtonSetup()
    }
    
}

//MARK: CollectionView Delegate
extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath[0] == 1 {
            let vc = ListTableViewController()
            vc.delegate = self
            vc.currentList = lists[indexPath.item]
            let nav = UINavigationController(rootViewController: vc)
            nav.modalTransitionStyle = .coverVertical
            nav.modalPresentationStyle = .fullScreen
            navigationController?.present(nav,animated: true)
            
        }
    }
    
}

//MARK: CollectionView DataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        
        if section == 1 {
            
            return lists.count
        }
        
        return 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath[0] == 0 {
          
            if indexPath.item == 0 {
         
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReminderTypeCollectionViewCell.reuseIdentifier, for: indexPath) as? ReminderTypeCollectionViewCell
                cell?.ReminderTypeCellBackground.backgroundColor =
                    UIColor { traitCollection in
                        
                        switch traitCollection.userInterfaceStyle {
                        case .dark:
                          
                            return UIColor.tertiarySystemGroupedBackground
                        default:
                          
                            return UIColor.white
                        }
                      }
                    
                cell?.configure(type: "All", count: String(allCount))
                return cell!
            }
            
            if indexPath.item == 1 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReminderTypeCollectionViewCell.reuseIdentifier, for: indexPath) as? ReminderTypeCollectionViewCell
                cell?.ReminderTypeCellBackground.backgroundColor =
                    UIColor { traitCollection in
                        
                        switch traitCollection.userInterfaceStyle {
                        case .dark:
                          
                            return UIColor.tertiarySystemGroupedBackground
                        default:
                          
                            return UIColor.white
                        }
                      }
                cell?.configure(type: "Flag", count: String(flaggedCount))
                return cell!

            }
         
        }
        
        if indexPath[0] == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCollectionViewCell.reuseIdentifier, for: indexPath) as? TableCollectionViewCell
            cell?.reminderBackgroundView.backgroundColor =
                UIColor { traitCollection in
                    
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                      
                        return UIColor.tertiarySystemGroupedBackground
                    default:
                      
                        return UIColor.white
                    }
                  }
            cell?.configure(
                name: lists[indexPath.item].name!,
                systemName: lists[indexPath.item].image!,
                hex: lists[indexPath.item].color!,
                count: Int(lists[indexPath.item].relation?.count ?? 0)
            )
            
            
            
            
            return cell!
        }
        
        return UICollectionViewCell()
     
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}

//MARK: createLayout

extension ViewController {
    private func createReminderTypeLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
}

//MARK: Searchbar Delegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableViewConfigure()
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.removeFromSuperview()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        isFiltering = false
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true
        filterContextForSearchText(searchText: searchText)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            
            return filteredReminders.count
        }
        else {
            return 0
        }
    
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFiltering {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
            cell.configure(title: filteredReminders[indexPath.row].title ?? " ", flagged: filteredReminders[indexPath.row].flagged, priority: filteredReminders[indexPath.row].priority ?? "None")
            return cell
        }
        else {
            
            return UITableViewCell()
        }
     
    }
    
}




