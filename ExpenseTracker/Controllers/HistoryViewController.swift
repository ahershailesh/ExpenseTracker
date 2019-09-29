//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var historyArray = [HistoryViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerViews()
        let leftAttributedString = NSAttributedString(string: "Left content")
        let rightAttributedString = NSAttributedString(string: "Right content")
        let array = [TwoLabelViewModel(leftAttributedString: leftAttributedString, rightAttributedString: rightAttributedString, backgroundColor: .red),
        TwoLabelViewModel(leftAttributedString: leftAttributedString, rightAttributedString: rightAttributedString, backgroundColor: .blue),
        TwoLabelViewModel(leftAttributedString: leftAttributedString, rightAttributedString: rightAttributedString, backgroundColor: .green)]
        
        let dateString = NSAttributedString(string: "Yesterday")
        let totalExpense = NSAttributedString(string: "500")
        
        historyArray = [HistoryViewModel(dateString: dateString, totalExpense: totalExpense, modelArray: array)]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func registerViews() {
        tableView.register(UINib(nibName: "TwoLabelTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TwoLabelTableViewCell.self))
        
        tableView.register(UINib(nibName: "HistorySectionView", bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: HistorySectionView.self))
    }
}

extension HistoryViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HistorySectionView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        view.model = historyArray[section]
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray[section].modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TwoLabelTableViewCell.self), for: indexPath) as? TwoLabelTableViewCell
        let history = historyArray[indexPath.section]
        cell?.viewModel = history.modelArray[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    
}

extension HistoryViewController : UITableViewDelegate {
    
}
