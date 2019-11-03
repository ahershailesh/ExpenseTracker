//
//  Global.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 05/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

protocol ViewModel {}

protocol BaseTableViewProtocol {
    associatedtype ViewModelType
    
    var viewModel : ViewModelType? { get set }
}

extension UITableView {
    
    func dequeue<T : UITableViewCell>() -> T? {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T
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

enum CellType {
    case label(viewModel: LabelViewModel)
    case button(viewModel: ButtonViewModel)
    
    func register(for tableView: UITableView) {
        switch self {
        case .label( _) : tableView.register(UINib(nibName: "LabelViewCell", bundle: nil), forCellReuseIdentifier: String(describing: LabelViewCell.self))
        case .button( _) : tableView.register(UINib(nibName: "ButtonViewCell", bundle: nil), forCellReuseIdentifier: String(describing: ButtonViewCell.self))
        }
    }
    
    func getCell(tableView: UITableView) -> UITableViewCell? {
        switch self {
        case .label(let viewModel):
            let cell : LabelViewCell? = tableView.dequeue()
            cell?.viewModel = viewModel
            return cell
        case .button(let viewModel):
            let cell : ButtonViewCell? = tableView.dequeue()
            cell?.viewModel = viewModel
            return cell
        }
    }
}
