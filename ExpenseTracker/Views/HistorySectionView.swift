//
//  HistorySectionView.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 29/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class HistorySectionView: UIView {

    private var leftLabel : UILabel?
    private var rightLabel : UILabel?
    
    var model: HistoryViewModel? {
        didSet {
            guard let model = model else { clean(); return }
            leftLabel?.attributedText = model.dateString
            rightLabel?.attributedText = model.totalExpense
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContraint()
    }
    
    private func setupContraint() {
        
        backgroundColor = .white
        
        leftLabel = UILabel()
        rightLabel = UILabel()
        
        leftLabel?.translatesAutoresizingMaskIntoConstraints = false
        rightLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(leftLabel!)
        addSubview(rightLabel!)
        
        leftLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        leftLabel?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
        
        leftLabel?.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        
        rightLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        rightLabel?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
        
        rightLabel?.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
    }
}
