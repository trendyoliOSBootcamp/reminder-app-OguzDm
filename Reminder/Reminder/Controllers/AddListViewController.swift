//
//  AddListViewController.swift
//  Reminders Clone
//
//  Created by Oguz Demırhan on 15.05.2021.
//

import UIKit
import CoreData

class AddListViewController: UIViewController {
    
    let imageBackground = UIView()
    let mainListImage = UIImageView()
    let textField = UITextField()
    let gradientLayer = CAGradientLayer()
    let colors = [UIColor.white,UIColor.red,UIColor.systemTeal,UIColor.purple,UIColor.systemPink,UIColor.blue,UIColor.green,UIColor.orange,UIColor.brown,UIColor.systemIndigo]
    let colorsWithHEX = ["#e93b81ff","#e93b81ff","#9fe6a0ff","#233e8bff","#e40017ff","#ff5200ff","#295939ff","#f8b400ff","#272343ff","#900c3fff"]
    let symbols = ["cloud.fill","pencil","folder","paperplane","trash","gamecontroller","house","dpad.fill","play.fill","hare","heart.fill","bandage","bed.double.fill","creditcard.fill","cart.fill","giftcard.fill","globe","alarm","hourglass","car","envelope.fill","moon.fill","briefcase.fill","guitars.fill","gift.fill","leaf.fill","text.book.closed.fill","graduationcap.fill","ticket.fill","key.fill","film.fill","shippingbox.fill","star.fill","terminal.fill","swift","eyes.inverse","gearshape.fill","puzzlepiece.fill","building.columns.fill","cpu","crown.fill","calendar","paperclip","umbrella.fill","bell.fill","tag.fill","scissors","hammer.fill","studentdesk","binoculars.fill"]
    var selectedColor = "#" + "\(UIColor.blue.toHex(alpha: true)!)"
    var selectedIcon = "list.bullet"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureController()
        imageBackGroundViewConfigure()
        textFieldConfigure()
        configureCollectionView()
        mainListImageViewConfigure()
    }
    
    private func configureController() {
        title = "New List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(leftBarAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(rightBarAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func leftBarAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rightBarAction() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let list = List(context: context)
        list.name = textField.text
        list.color = selectedColor
        list.image = selectedIcon
        list.count = 0
        
        do {
            try context.save()
        }
        catch{
            print(error.localizedDescription)
        }
        
            let vc = UINavigationController(rootViewController: ViewController())
            vc.modalPresentationStyle = .fullScreen
        
            self.navigationController?.present(vc,animated: false)
      
    }
    
    @objc func textFieldDidChange() {
        
        if textField.text == "" {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    private func imageBackGroundViewConfigure() {
        
        imageBackground.backgroundColor = .blue
        imageBackground.layer.cornerRadius = 50
        view.addSubview(imageBackground)
        
        NSLayoutConstraint.activate([
            imageBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
            imageBackground.heightAnchor.constraint(equalToConstant: 100),
            imageBackground.widthAnchor.constraint(equalToConstant: 100),
            imageBackground.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func mainListImageViewConfigure() {
        
        mainListImage.image = UIImage(systemName: "list.bullet")
        mainListImage.tintColor = .white
        mainListImage.contentMode = .scaleAspectFit
        view.addSubview(mainListImage)
        view.bringSubviewToFront(mainListImage)
        
        NSLayoutConstraint.activate([
            mainListImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 70),
            mainListImage.heightAnchor.constraint(equalToConstant: 60),
            mainListImage.widthAnchor.constraint(equalToConstant: 60),
            mainListImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        mainListImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func textFieldConfigure () {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.textColor = .blue
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .tertiarySystemGroupedBackground
        view.addSubview(textField)
        NSLayoutConstraint.activate([
        
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 175),
            textField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -10),
            textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 55)
        
        ])
        
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCircleCell())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.loadNib(name: CircleCollectionViewCell.reuseIdentifier), forCellWithReuseIdentifier: CircleCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
        
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 250),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
   
    
    private func createCircleCell() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 10 , bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.175))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
    }
    
}

extension AddListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if indexPath[0] == 0 {
            
            if indexPath.item == 0 {
                
                let colorPicker = UIColorPickerViewController()
                colorPicker.delegate = self
                self.present(colorPicker, animated: true, completion: nil)
            }
            else {
                imageBackground.backgroundColor = UIColor(hex: colorsWithHEX[indexPath.item])
                textField.textColor = UIColor(hex: colorsWithHEX[indexPath.item])
                selectedColor = colorsWithHEX[indexPath.item]
            }
        }
        
        if indexPath[0] == 1 {
            mainListImage.image = UIImage(systemName: symbols[indexPath.item])
            selectedIcon = symbols[indexPath.item]
        }
       
    }
    
}

extension AddListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return colorsWithHEX.count
        default:
            return symbols.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCollectionViewCell.reuseIdentifier, for: indexPath) as! CircleCollectionViewCell
        
        if indexPath[0] == 0 {
        
            if indexPath.item == 0{
                
                gradientLayer.type = .conic
                gradientLayer.frame = cell.circleCellBackground.bounds
                gradientLayer.colors = [
                    UIColor.purple.cgColor,
                    UIColor.blue.cgColor,
                    UIColor.green.cgColor,
                    UIColor.yellow.cgColor,
                    UIColor.orange.cgColor,
                    UIColor.red.cgColor
                
                ]
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
                let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
                gradientLayer.endPoint = CGPoint(x: 1, y: endY)
                gradientLayer.cornerRadius = cell.circleCellBackground.frame.width / 2
                cell.circleCellBackground.layer.addSublayer(gradientLayer)
                cell.circleCellImageView.image = UIImage(systemName: "")
                
                return cell
            }
            else {
                cell.circleCellBackground.backgroundColor = UIColor(hex: colorsWithHEX[indexPath.item])
                cell.circleCellImageView.image = UIImage(systemName: "")
                
                return cell
            }
           
        }
        
        if indexPath[0] == 1 {
            cell.circleCellBackground.backgroundColor = .tertiarySystemGroupedBackground
            cell.circleCellImageView.image = UIImage(systemName: symbols[indexPath.item] )
            cell.circleCellImageView.tintColor = .gray
            if let _ = cell.circleCellBackground.layer.sublayers?.compactMap({ $0 as? CAGradientLayer}).first {
                
                gradientLayer.removeFromSuperlayer()
            }
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}

extension AddListViewController : UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        imageBackground.backgroundColor = viewController.selectedColor
        textField.textColor = viewController.selectedColor
        selectedColor = "#" + "\(viewController.selectedColor.toHex(alpha: true)!)"
    }
}



