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
        let expenseViewModel = ExpenseViewModel(expenseAmount: nil, note: nil, categoryName: "Select", categoryTag: "--", date: Date())
        expenseController = AddExpenseViewController(model: expenseViewModel)
        expenseController?.delegate = self
        expenseController?.navigationItem.title = "Add Expense"
        present(UINavigationController(rootViewController: expenseController!) , animated: true, completion: nil)
    }
}

extension HomeViewController : AddExpenseViewControllerDelegate {
    func addExpense(_ expenseModel: ExpenseViewModel) {
        DataManger.addExpense(expenseModel)
        expenseController?.dismiss(animated: true, completion: nil)
    }
}
