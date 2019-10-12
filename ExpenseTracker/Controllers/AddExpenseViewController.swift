//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 29/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

protocol AddExpenseViewControllerDelegate : class {
    func addExpense(_ expenseModel: ExpenseViewModel)
}

struct ExpenseViewModel {
    var expenseAmount : Int16?
    var note : String?
    var categoryName: String
    var categoryTag: String
}

final class AddExpenseViewController: UIViewController {
    
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate : AddExpenseViewControllerDelegate?
    
    var expenseViewModel : ExpenseViewModel? {
        didSet {
            guard let model = expenseViewModel else { return }
            setupView(with: model)
        }
    }
    
    convenience init(model: ExpenseViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.expenseViewModel = model
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = expenseViewModel {
            setupView(with: model)
        }
    }
    
    private func setupView(with model: ExpenseViewModel) {
        categoryLabel.text = model.categoryName
        tagLabel.text = model.categoryTag
        expenseTextField.text = model.expenseAmount?.description
        noteTextField.text = model.note
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard var model = expenseViewModel else { return }
        model.note = noteTextField.text
        if let text = expenseTextField.text, let amount = Int16(text) {
            model.expenseAmount = amount
        }
        delegate?.addExpense(model)
    }
}
