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
    
    private var context : NSManagedObjectContext {
        return CoreDataManager.shared.container.viewContext
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
        listViewController = ListingViewController()
        let tags = try? context.fetch(Tag.fetchRequest())
        listViewController?.contents = tags?.compactMap { return ($0 as AnyObject).title } ?? []
        listViewController?.delegate = self
        present(listViewController!, animated: true, completion: nil)
    }
    
    private func createTags(with name: String) {
        let createTagController = ColorPickerViewController()
        let navController = UINavigationController(rootViewController: createTagController)
        createTagController.title = name
        createTagController.colors = [.blue, .gray, .green, .brown, .darkGray, .darkText]
        present(navController, animated: true, completion: nil)
    }
}

extension SettingsViewController : ListingViewControllerDelegate {
    func createNew(_ listItem: String) {
        listViewController?.dismiss(animated: true, completion: nil)
        createTags(with: listItem)
    }
    
    func selectedListItem(_ listItem : String) {
        listViewController?.dismiss(animated: true, completion: nil)
    }
}
