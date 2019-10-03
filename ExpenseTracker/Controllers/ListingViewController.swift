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
        let section1 = addCreateSection(with: searchText)
        let section2 = filter(with: searchText)
        viewModels = [section1, section2].compactMap { $0 }
        tableView.reloadData()
    }
    
    private func filter(with text: String) -> SectionListItem? {
        let items = filterItems(for: text)
        let allList = getMappedViewModels(from: items)
        if !allList.isEmpty {
            return SectionListItem(items: allList, title: NSAttributedString(string: TITLE, attributes: sectionHeaderAttribute))
        }
        return nil
    }
    
    private func addCreateSection(with text: String) -> SectionListItem? {
        
        guard !text.isEmpty,
        !contents.contains(text.trimmingCharacters(in: .whitespaces)) else {
            viewModels.removeFirst()
            tableView.reloadData()
            return nil
        }
        let newItem = [ListItem(attributedString: NSAttributedString(string: text, attributes: attributes))]
        return SectionListItem(items: newItem, title: NSAttributedString(string: NEW_SECTION_TITLE, attributes: sectionHeaderAttribute))
    }
    
    private func filterItems(for text: String) -> [String] {
        guard !text.isEmpty else { return contents }
        
        return contents.filter { (content) -> Bool in
            return content.contains(text)
        }
    }
    
    private func getMappedViewModels(from array: [String]) -> [ListItem] {
        return array.map { return ListItem(attributedString: NSAttributedString(string: $0, attributes: attributes)) }
    }
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
