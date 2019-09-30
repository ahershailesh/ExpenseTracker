//
//  ItemPicker.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 29/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class ItemPicker: UITextField {

    var picker : UIPickerView?
    
    var dataArray = [String]()
    var callBack: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupData()
    }
    
    private func setupData() {
        picker = UIPickerView(frame: .zero)
        picker?.backgroundColor = .lightGray
        picker?.delegate = self
        picker?.dataSource = self
    }
    
    func show() {
        inputView = picker
        setupToolBar()
        becomeFirstResponder()
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector( donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputAccessoryView = toolBar
    }
    
    @objc private func donePicker() {
        if let selectedIndex = picker?.selectedRow(inComponent: 0) {
            resignFirstResponder()
            callBack?(dataArray[selectedIndex])
        }
    }
    
    @objc private func cancelPicker() {
         resignFirstResponder()
    }
    
}

extension ItemPicker : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
}

extension ItemPicker : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
