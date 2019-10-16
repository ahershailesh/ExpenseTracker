//
//  TextFieldTableViewCell.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 15/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

struct TextFieldViewModel {
    var placeHolder: String
    var text: NSAttributedString?
    var type : UIKeyboardType
}

class TextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var model : TextFieldViewModel? {
        didSet {
            guard let model = model else { return }
            if let text = model.text {
                textField.attributedText = text
            }
            textField.placeholder = model.placeHolder
            textField.keyboardType = model.type
        }
    }
    
    var updatedText : String? {
        return textField?.text
    }
}
