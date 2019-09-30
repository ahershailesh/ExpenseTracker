//
//  TwoLabelTableViewCell.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class TwoLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var viewModel : TwoLabelViewModel? {
        didSet {
            guard let viewModel = viewModel else { clear(); return }
            leftLabel.attributedText = viewModel.leftAttributedString
            rightLabel.attributedText = viewModel.rightAttributedString
            containerView.backgroundColor = viewModel.backgroundColor
            containerView.layer.cornerRadius = 8
            selectionStyle = .none
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
    
    private func clear() {
        leftLabel.attributedText = nil
        rightLabel.attributedText = nil
        containerView.backgroundColor = .white
    }
}
