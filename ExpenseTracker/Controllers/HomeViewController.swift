//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    private var categoryController : ListingViewController?
    private var categories : [Category] = []
    private var expenseController : AddExpenseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private var attributes : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.black]
    }

    @objc private func addButtonTapped() {
        categoryController = ListingViewController(canShowAddNewItemIfNotMatched: false, delegate: self)
        let navigationController = UINavigationController(rootViewController: categoryController!)
        let categories = DataManger.getCategories(with: "")
        categoryController?.contents = categories.map({ (category) -> ListItem in
            let attributedString = NSAttributedString(string: category.title ?? "", attributes: attributes)
            return ListItem(attributedString: attributedString, backgroundColor: (category.tag?.color as? UIColor) ?? UIColor.white)
        })
        categoryController?.navigationItem.title = "Choose category"
        present(navigationController, animated: true, completion: nil)
    }
    
    private func addExpense(category: Category) {
        let expenseViewModel = ExpenseViewModel(expenseAmount: nil, note: nil, categoryName: category.title ?? "", categoryTag: category.tag?.title ?? "")
        
        expenseController = AddExpenseViewController(model: expenseViewModel)
        expenseController?.delegate = self
        expenseController?.navigationItem.title = "Add Expense"
        present(UINavigationController(rootViewController: expenseController!) , animated: true, completion: nil)
    }
}

extension HomeViewController : ListingViewControllerDelegate {
    func createNew(_ listItem: String) {
        categoryController?.dismiss(animated: true, completion: nil)
    }
    
    func selectedListItem(_ listItem : String) {
        if let cateogory = DataManger.getCategories(with: listItem).first {
            categoryController?.dismiss(animated: true, completion: nil)
            addExpense(category: cateogory)
        }
    }
}

extension HomeViewController : AddExpenseViewControllerDelegate {
    func addExpense(_ expenseModel: ExpenseViewModel) {
        DataManger.addExpense(expenseModel)
        expenseController?.dismiss(animated: true, completion: nil)
    }
}
