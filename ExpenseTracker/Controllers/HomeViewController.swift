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
        setupCategories()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addButtonTapped() {
        categoryController = ListingViewController(canShowAddNewItemIfNotMatched: false, delegate: self)
        let navigationController = UINavigationController(rootViewController: categoryController!)
        categoryController?.contents = categories.compactMap { $0.title }
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
    
    private func setupCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [titleSortDescriptor]
        do {
            categories = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Found error while fetching categories")
        }
    }
}

extension HomeViewController : ListingViewControllerDelegate {
    func createNew(_ listItem: String) {
        categoryController?.dismiss(animated: true, completion: nil)
    }
    
    func selectedListItem(_ listItem : String) {
        if let cateogory = categories.first(where: { listItem == $0.title }) {
            categoryController?.dismiss(animated: true, completion: nil)
            addExpense(category: cateogory)
        }
    }
}

extension HomeViewController : AddExpenseViewControllerDelegate {
    func addExpense(_ expenseModel: ExpenseViewModel) {
        let expense = Expense(context: CoreDataManager.shared.context)
        expense.timeStamp = Date()
        expense.spend = expenseModel.expenseAmount ?? 0
        expense.category = categories.first(where: { (cateogory) -> Bool in
            return cateogory.title == expenseModel.categoryName
        })
        expense.note = expenseModel.note
        CoreDataManager.shared.save()
        expenseController?.dismiss(animated: true, completion: nil)
    }
}
