//
//  SettingsViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 29/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let sections : [SettingsConstant] = [.tags]
    var listViewController : ListingViewController?
    var colorPickerController : ColorPickerViewController?
    private var selectedTag : Tag?
    
    private var context : NSManagedObjectContext {
        return CoreDataManager.shared.container.viewContext
    }
    
    private var attributes : [NSAttributedString.Key : Any] {
           return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                   NSAttributedString.Key.foregroundColor : UIColor.black]
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = sections[indexPath.row].rawValue
        cell.selectionStyle = .none
        return cell
    }
}

extension SettingsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath),
            let title = cell.textLabel?.text,
            let enumValue = SettingsConstant(rawValue: title) {
            switch enumValue {
            case .tags:
                openTagsController()
            default: break
            }
        }
        
    }
    
    private func openTagsController() {
        listViewController = ListingViewController(canShowAddNewItemIfNotMatched: true, delegate: self)
        let navigationController = UINavigationController(rootViewController: listViewController!)
        listViewController?.navigationItem.title = "All Tag"
        let tags = DataManger.getTags(with: "")
        listViewController?.contents = tags.compactMap { tag in
            if let title = tag.title {
                let item = ListItem(attributedString: NSAttributedString(string: title, attributes: attributes), backgroundColor: tag.color as? UIColor)
                return item
            }
            return nil
        }
        present(navigationController, animated: true, completion: nil)
    }
    
    private func openTag(_ tag: Tag) {
        colorPickerController = ColorPickerViewController()
        let navController = UINavigationController(rootViewController: colorPickerController!)
        colorPickerController?.delegate = self
        colorPickerController?.title = tag.title
        colorPickerController?.colorModels = Color.all.map { return ColorViewModel(color: $0, isSelected: false) }
        present(navController, animated: true, completion: nil)
    }
}

extension SettingsViewController : ListingViewControllerDelegate {
    func createNew(_ listItem: String) {
        listViewController?.dismiss(animated: true, completion: nil)
        let tag = DataManger.newTag(with: listItem)
        selectedTag = tag
        openTag(tag)
    }
    
    func selectedListItem(_ listItem : String) {
        listViewController?.dismiss(animated: true, completion: nil)
        if let tag = DataManger.getTags(with: listItem).first {
            selectedTag = tag
            openTag(tag)
        }
    }
}

extension SettingsViewController : ColorPickerDelegate {
    func didSelectedcolor(color: UIColor) {
        selectedTag?.color = color
        CoreDataManager.shared.save()
        colorPickerController?.dismiss(animated: true, completion: nil)
    }
}
