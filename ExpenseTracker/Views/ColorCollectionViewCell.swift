//
//  ColorCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 13/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    var model : ColorViewModel? {
        didSet {
            guard let model = model else { return }
            color = model.color
            isSelected = model.isSelected
        }
    }
    
    var color : UIColor = UIColor.white {
        didSet {
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 64 / 2
        }
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = 0
            if isSelected {
                contentView.layer.borderColor = UIColor.gray.cgColor
                contentView.layer.borderWidth = 2
            }
            contentView.layer.cornerRadius = contentView.layer.frame.width / 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
