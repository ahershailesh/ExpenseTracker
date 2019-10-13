//
//  ListingViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 30/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

struct ListItem {
    var attributedString : NSAttributedString
    var backgroundColor : UIColor?
}

private struct SectionListItem {
    var items : [ListItem]
    var title : NSAttributedString
}

protocol ListingViewControllerDelegate : class {
    func selectedListItem(_ listItem : String)
    func createNew(_ listItem : String)
}

final class ListingViewController: UIViewController {

    enum ListingSection : String {
        case new = "Create new"
        case all = "All"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate : ListingViewControllerDelegate?
    
    private var attributes : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    private var sectionHeaderAttribute : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor : UIColor.gray]
    }
    
    private var viewModels : [SectionListItem] = []
    private var searchString : String?
    private var showAddNewItemIfNotMatched = false
    private var isSearchEnabled = false
    private var isSearchMatched = false
    
    var contents : [ListItem] = [] {
        didSet {
            if !contents.isEmpty {
                viewModels = [SectionListItem(items: contents, title: NSAttributedString(string: ListingSection.all.rawValue, attributes: sectionHeaderAttribute))]
                isSearchEnabled = true
            } else {
                viewModels = [SectionListItem(items: [], title: NSAttributedString(string: "Create new by typing in search box", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]))]
                isSearchEnabled = false
                showAddNewItemIfNotMatched = true
            }
        }
    }
    
    convenience init(canShowAddNewItemIfNotMatched : Bool, delegate: ListingViewControllerDelegate? = nil) {
        self.init(nibName: nil, bundle: nil)
        showAddNewItemIfNotMatched = canShowAddNewItemIfNotMatched
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
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
        if !items.isEmpty {
            return SectionListItem(items: items, title: NSAttributedString(string: ListingSection.all.rawValue, attributes: sectionHeaderAttribute))
        }
        return nil
    }
    
    private func addCreateSection(with text: String) -> SectionListItem? {
        searchString = text
        guard !text.isEmpty, showAddNewItemIfNotMatched,
            contents.first(where: { $0.attributedString.string == text.trimmingCharacters(in: .whitespaces)}) == nil else {
            return nil
        }
        
        let newItem = [ListItem(attributedString: NSAttributedString(string: text, attributes: attributes))]
        return SectionListItem(items: newItem, title: NSAttributedString(string: ListingSection.new.rawValue, attributes: sectionHeaderAttribute))
    }
    
    private func filterItems(for text: String) -> [ListItem] {
        guard !text.isEmpty else { return contents }
        
        return contents.filter { (content) -> Bool in
            return content.attributedString.string.contains(text)
        }
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
        cell.backgroundColor = viewModels[indexPath.section].items[indexPath.row].backgroundColor
        cell.selectionStyle = .none
        return cell
    }
}

extension ListingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModels[indexPath.section].items[indexPath.row]
        let sectionValue = viewModels[indexPath.section].title.string
        guard let sectionItem = ListingSection(rawValue: sectionValue) else {
            return
        }
        
        switch sectionItem {
        case .new:
            delegate?.createNew(item.attributedString.string)
        default:
            delegate?.selectedListItem(item.attributedString.string)
        }
    }
}
