//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 29/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

final class AddExpenseViewController: UIViewController {

    private var picker : ItemPicker?
    private let PICKER_HEIGHT : CGFloat = 200
    
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var addExpenseView: UIView!
    
    private var categoryData : [String] {
        return ["Category1", "Category2"]
    }
    
    private var tagData : [String] {
        return ["Tag1", "Tag2"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        registerForNotifications()
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(sender:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardShown(sender: Notification) {

    }
    
    @objc private func keyboardHide(sender: Notification) {
        
    }
    
    private func setupButtons() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveExpense))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = cancelButton
        
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        tagButton.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveExpense() {
        dismissController()
    }
    
    @objc private func categoryButtonTapped() {
        showPicker(with: categoryData) { [weak self] selection in
            self?.categoryButton.setTitle(selection, for: .normal)
        }
    }
    
    @objc private func tagButtonTapped() {
        showPicker(with: tagData) { [weak self] selection in
            self?.tagButton.setTitle(selection, for: .normal)
        }
    }
    
    private func showPicker(with dataArray: [String], callBack: @escaping (String) -> Void) {
        picker = ItemPicker(frame: .zero)
        picker?.callBack = { [weak self] selection in
            self?.removePicker()
            callBack(selection)
        }
        picker?.dataArray = dataArray
        view.addSubview(picker!)
        picker?.show()
    }
    
    func removePicker() {
        picker = nil
    }
    
    @objc private func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}
