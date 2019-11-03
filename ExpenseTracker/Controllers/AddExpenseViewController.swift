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
    var date : Date
}

final class AddExpenseViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var picker: UIDatePicker?
    private var toolBar : UIToolbar?
    private var listViewController : ListingViewController?
    private var placeHolderCategoryName = "Select"
    
    private let expenseAmountIndexPath = IndexPath(row: 0, section: 0)
    private let noteIndexPath = IndexPath(row: 1, section: 0)
    
    weak var delegate : AddExpenseViewControllerDelegate?
    
    
    private var attributes : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    private var lightAttributes : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.gray]
    }
    
    private var model : ExpenseViewModel? {
        didSet {
            setupModel(model: model)
        }
    }
    
    private var dateString : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY, hh:mm a"
        if let date = model?.date {
            return dateFormatter.string(from: date)
        }
        return "---"
    }
    
    private var textFieldModels = [TextFieldViewModel]()
    private var labelModels = [TwoLabelViewModel]()
    
    convenience init(model: ExpenseViewModel?) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .lightText
        
        setupModel(model: model)
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveButtonTapped() {
        
        guard let cell = tableView.cellForRow(at: expenseAmountIndexPath) as? TextFieldTableViewCell,
            let spendString = cell.updatedText, let spendAmount = Int16(spendString) else {
            showAlert(with: "Enter money spent", message: "")
            return
        }
        
        guard let categoryName = model?.categoryName, categoryName != placeHolderCategoryName else {
            showAlert(with: "Please select Category", message: "")
            return
        }
        model?.expenseAmount = spendAmount
        model?.note = (tableView.cellForRow(at: noteIndexPath) as? TextFieldTableViewCell)?.updatedText
        
        dismiss(animated: true) { [weak self] in
            if let model = self?.model {
                self?.delegate?.addExpense(model)
            }
        }
    }
    
    private func showAlert(with title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupModel(model: ExpenseViewModel?) {
        
        let data : [(String, Any?, UIKeyboardType)] =
            [("Amount in ruppe" , model?.expenseAmount, .numberPad),
             ("Note", model?.note, .alphabet)]
            
          textFieldModels = data.map { placeHolder, value, type in
            var attributedString : NSAttributedString?
            if let value = value {
                attributedString = NSAttributedString(string: "\(value)")
            }
            return TextFieldViewModel(placeHolder: placeHolder, text: attributedString, type: type)
        }
        
        let titleAttribute = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .medium)]
        
        let details = [("Date", titleAttribute, dateString, lightAttributes, UITableViewCell.AccessoryType.none),
                       ("Category", titleAttribute, model?.categoryName ?? placeHolderCategoryName, lightAttributes, UITableViewCell.AccessoryType.disclosureIndicator),
                       ("Tag", titleAttribute, model?.categoryTag ?? "--", lightAttributes, UITableViewCell.AccessoryType.none)]
        
        labelModels = details.map { title, titleAttribute, subTitle, subTitleAttribute, type  in
            let titleAttributedString = NSAttributedString(string: title, attributes: titleAttribute)
            let subTitleAttributedString = NSAttributedString(string: subTitle, attributes: subTitleAttribute)
            return TwoLabelViewModel(leftAttributedString: titleAttributedString, rightAttributedString: subTitleAttributedString, backgroundColor: .white, accessoryType: type)
        }
        
        tableView.reloadData()
    }
    
    private func getTextViewCellsCount() -> Int {
        return 2
    }
    
    private func getSelectionCellsCount() -> Int {
        return 3
    }

    private func registerCells() {
        tableView.register(UINib(nibName: "TwoLabelTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TwoLabelTableViewCell.self))
        
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TextFieldTableViewCell.self))
    }
    
}

extension AddExpenseViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightText
        return view
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return getTextViewCellsCount()
        default:
            return getSelectionCellsCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldTableViewCell.self), for: indexPath) as? TextFieldTableViewCell
            cell?.model = textFieldModels[indexPath.row]
            return cell ?? UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TwoLabelTableViewCell.self), for: indexPath) as? TwoLabelTableViewCell
            cell?.viewModel = labelModels[indexPath.row]
            return cell ?? UITableViewCell()
        }
    }
    
    private func showDatePicker() {
        picker = UIDatePicker()
        view.addSubview(picker!)
        picker?.translatesAutoresizingMaskIntoConstraints = false
        picker?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        picker?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        picker?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        if let date = model?.date {
            picker?.date = date
        }
        
        toolBar = UIToolbar()
        view.addSubview(toolBar!)
        toolBar?.backgroundColor = UIColor.gray
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolBar?.items = [spacer, doneButton]
        toolBar?.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar?.bottomAnchor.constraint(equalTo: picker!.topAnchor).isActive = true
        toolBar?.leadingAnchor.constraint(equalTo: picker!.leadingAnchor).isActive = true
        toolBar?.trailingAnchor.constraint(equalTo: picker!.trailingAnchor).isActive = true
        
        picker?.backgroundColor = .white
        picker?.datePickerMode = .dateAndTime
    }
    
    private func showCategories() {
        listViewController = ListingViewController(canShowAddNewItemIfNotMatched: false, delegate: self)
        let navigationController = UINavigationController(rootViewController: listViewController!)
        listViewController?.navigationItem.title = "Select Categories"
        let categories = DataManger.getCategories(with: "")
        listViewController?.contents = categories.compactMap { category in
            if let title = category.title {
                let item = ListItem(attributedString: NSAttributedString(string: title, attributes: attributes), backgroundColor: category.tag?.color as? UIColor)
                return item
            }
            return nil
        }
        listViewController?.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        if let date = picker?.date {
            model?.date = date
        }
        
        setupModel(model: model)
        
        picker?.removeFromSuperview()
        toolBar?.removeFromSuperview()
    }
}

extension AddExpenseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            showDatePicker()
        case (1, 1):
            showCategories()
        default:
            break
        }
    }
}

extension AddExpenseViewController : ListingViewControllerDelegate {
    func selectedListItem(_ listItem: String) {
        model?.categoryName = listItem
        model?.categoryTag = DataManger.getCategories(with: listItem).first?.tag?.title ?? "--"
        listViewController?.dismiss(animated: true, completion: nil)
        setupModel(model: model)
    }
    
    func createNew(_ listItem: String) {
        model?.categoryName = listItem
        model?.categoryTag = DataManger.getCategories(with: listItem).first?.tag?.title ?? "--"
        listViewController?.dismiss(animated: true, completion: nil)
        setupModel(model: model)
    }
}
