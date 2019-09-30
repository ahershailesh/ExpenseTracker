//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addButtonTapped() {
        let expenseController = AddExpenseViewController(nibName: "AddExpenseViewController", bundle: nil)
        present(UINavigationController(rootViewController: expenseController) , animated: true, completion: nil)
    }
    
}
