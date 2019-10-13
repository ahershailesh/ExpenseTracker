//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var historyArray = [HistoryViewModel]()
    var historyFRC : NSFetchedResultsController<Expense>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "History"
        registerViews()
        prepareData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareData()
    }
    
    private func prepareData() {
        
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        
        historyFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: "dateString", cacheName: nil)
        historyFRC?.delegate = self
        do {
            try historyFRC?.performFetch()
        } catch {
            
        }
        tableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        let expenseController = AddExpenseViewController(nibName: "AddExpenseViewController", bundle: nil)
        present(UINavigationController(rootViewController: expenseController) , animated: true, completion: nil)
    }
    
    private func registerViews() {
        tableView.register(UINib(nibName: "TwoLabelTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TwoLabelTableViewCell.self))
        
        tableView.register(UINib(nibName: "HistorySectionView", bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: HistorySectionView.self))
    }
}

extension HistoryViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HistorySectionView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        let dateString = historyFRC?.object(at: IndexPath(row: 0, section: section)).dateString ?? ""
        let expense = historyFRC?.sections?[section].objects?.reduce(0, { (result, element) -> Int in
            return result + Int((element as? Expense)?.spend ?? 0)
        }) ?? 0
        view.model = HistoryViewModel(dateString: NSAttributedString(string: dateString), totalExpense: NSAttributedString(string: "₹ \(expense)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        return view
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyFRC?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyFRC?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return historyFRC?.object(at: IndexPath(row: 0, section: section)).dateString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TwoLabelTableViewCell.self), for: indexPath) as? TwoLabelTableViewCell
        if let object = historyFRC?.object(at: indexPath),
            let categoryTitle = object.category?.title {
            let leftAttributedString = NSAttributedString(string: categoryTitle)
            let rightAttributedString = NSAttributedString(string: "₹ \(object.spend)")
            cell?.viewModel = TwoLabelViewModel(leftAttributedString: leftAttributedString, rightAttributedString: rightAttributedString, backgroundColor: (object.category?.tag?.color as? UIColor) ?? .white)
        }
        return cell ?? UITableViewCell()
    }
    
    
}

extension HistoryViewController : UITableViewDelegate {
    
}

extension HistoryViewController : NSFetchedResultsControllerDelegate {
    
}
