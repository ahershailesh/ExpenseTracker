//
//  ButtonViewCell.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 27/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

struct ButtonViewModel {
    var text : NSAttributedString
    var viewBackgroundColor : UIColor
    var buttonBackgroundColor : UIColor
    var forgroundColor : UIColor
    var fixWidth : CGFloat?
    
    var curve : Curve
    var tap : () -> Void
}


class ButtonViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthContraint: NSLayoutConstraint!
    
    
    private var actionBlock: (() -> Void)?
    
    var viewModel: ButtonViewModel? {
        didSet {
            setupView()
            setupModel(model: viewModel)
        }
    }
    
    var curve : Curve = .none {
        didSet {
            switch curve {
            case .top(let radius, let margin):
                containerView.roundCorners(corners: [.topLeft, .topRight], radius: radius)
                topContainerConstraint.constant = margin
            case .bottom(let radius, let margin):
                containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
                bottomContainerConstraint.constant = margin
            case .both(let radius, let margin):
                containerView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: radius)
                topContainerConstraint.constant = margin
                bottomContainerConstraint.constant = margin
            default:
                containerView.roundCorners(corners: [], radius: 0)
                topContainerConstraint.constant = 0
                bottomContainerConstraint.constant = 0
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanCell()
    }
    
    private func setupModel(model: ButtonViewModel?) {
        if let model = model {
            button.setAttributedTitle(model.text, for: .normal)
            containerView.backgroundColor = model.viewBackgroundColor
            button.backgroundColor = model.buttonBackgroundColor
            button.layer.cornerRadius = 8
            curve = model.curve
            backgroundColor = .clear
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            actionBlock = model.tap
            if let fixWidth = model.fixWidth {
                buttonWidthContraint.isActive = true
                buttonWidthContraint.constant = fixWidth
            } else {
                buttonWidthContraint.isActive = false
            }
        } else {
            cleanCell()
        }
    }
    
    private func setupView() {
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    private func cleanCell() {
        button.setAttributedTitle(nil, for: .normal)
        curve = .none
        actionBlock = nil
    }
    
    @objc private func buttonTapped() {
        actionBlock?()
    }
}
