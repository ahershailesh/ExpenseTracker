//
//  ListingViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 30/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

private struct ListItem {
    var attributedString : NSAttributedString
}

private struct SectionListItem {
    var items : [ListItem]
    var title : NSAttributedString
}

final class ListingViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var attributes : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    private var sectionHeaderAttribute : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor : UIColor.gray]
    }
    
    private let NEW_SECTION_TITLE = "Create new"
    private let TITLE = "All"
    
    private var viewModels : [SectionListItem] = []
    private var searchString : String?
    
    var contents : [String] = [] {
        didSet {
            let array = contents.map { return ListItem(attributedString: NSAttributedString(string: $0, attributes: attributes))
            }
            viewModels = [SectionListItem(items: array, title: NSAttributedString(string: TITLE, attributes: sectionHeaderAttribute))]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
    }
    
    private func registerCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ListingViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(with: searchText)
    }
    
    private func filter(with text: String) {
        
        addSection(with: text)
        
        tableView.reloadData()
    }
    
    private func addSection(with text: String) {
        guard !text.isEmpty else {
            viewModels.removeFirst()
            tableView.reloadData()
            return
        }
        let newItem = [ListItem(attributedString: NSAttributedString(string: text, attributes: attributes))]
        if viewModels.count == 2 {
            viewModels.removeFirst()
        }
        let sectionItem = SectionListItem(items: newItem, title: NSAttributedString(string: NEW_SECTION_TITLE, attributes: sectionHeaderAttribute))
        
        viewModels.insert(sectionItem, at: 0)
    }
    
//    private func filterItems(from text: String) {
//        let items =
//    }
}

extension ListingViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewCell()
        view.textLabel?.attributedText = viewModels[section].title
        return view
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.attributedText = viewModels[indexPath.section].items[indexPath.row].attributedString
        cell.selectionStyle = .none
        return cell
    }
}

extension ListingViewController : UITableViewDelegate {
    
}
