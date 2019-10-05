//
//  SettingsViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 29/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let sections : [SettingsConstant] = [.createCategory,
    .createTag]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
            case .createCategory:
                openCategoryController()
            case .createTag:
                openTagsController()
            }
        }
        
    }
    
    private func openCategoryController() {
        let categoryController = ListingViewController()
        categoryController.contents = ["Category 1", "Category 2", "Category 3"]
        present(categoryController, animated: true, completion: nil)
    }
    
    private func openTagsController() {
        let tagsController = ListingViewController()
        tagsController.contents = ["Tag 1", "Tag 2", "Tag 3"]
        present(tagsController, animated: true, completion: nil)
    }
}
