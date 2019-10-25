//
//  LabelViewCell.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 21/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

protocol CardViewType { }

enum Curve : CardViewType {
    case top(radius: CGFloat, margin: CGFloat), bottom(radius: CGFloat, margin: CGFloat), both(radius: CGFloat,  margin: CGFloat), none
}

struct LabelViewModel {
    var alignment : NSTextAlignment
    var text : NSAttributedString
    var backgroundColor : UIColor
}

//protocol CardView {
//
//    associatedtype curve : CardViewType
//    associatedtype contentView : UIView
//
//    func setCurve(curve : CardViewType)
//}
//
//extension CardView {
//    func setCurve(curve : Curve) {
//        switch curve {
//        case .bottom : self.contentView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
//        case .top :
//        case .none :
//        }
//    }
//}

class LabelViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    
    
    var viewModel : LabelViewModel? {
        didSet {
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
    
    private func setupModel(model: LabelViewModel?) {
        if let model = model {
            label.textAlignment = model.alignment
            label.attributedText = model.text
            containerView.backgroundColor = model.backgroundColor
        } else {
            cleanCell()
        }
    }
    
    private func cleanCell() {
        label.textAlignment = .left
        label.attributedText = nil
    }
    
   
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}