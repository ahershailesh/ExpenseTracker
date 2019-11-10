//
//  HomeViewManager.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 01/11/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

protocol PresentationProtocol {
    func present(controller: UIViewController, animated: Bool)
    func refresh()
}

protocol CardProtocol {
    var presenter: PresentationProtocol? { get set }
    func getCards() -> [CellType]
}

class HomeViewManager : CardProtocol {
    
    var presenter: PresentationProtocol?
    var expenseController : AddExpenseViewController?
    
    private let bottomCurve : Curve = .bottom(radius: 8, margin: 8)
    private let topCurve : Curve = .top(radius: 8, margin: 8)
    
    func getCards() -> [CellType] {
        var cards = getSpendTodayCard()
        cards.append(contentsOf: getTatalExpenseCard())
        cards.append(contentsOf: getBarChartCell())
        return cards
    }
    
    private func getSpendTodayCard() -> [CellType] {
        
        var cellTypes = [CellType]()
        
        var addExpsenseMessage = Strings.NO_EXPENSE_RECORDED_MESSAGE
        var buttonMessage = Strings.ADD_SOME_EXPENSE_MESSAGE
        
        // I need to take width, because I need extra spece in the button
        var buttonWidth : CGFloat = 190
        if let totalExpense = getTodaysTotalExpenses() {
            addExpsenseMessage = Strings.TOTAL_EXPENSE_TODAY
            addExpsenseMessage = addExpsenseMessage.replacingOccurrences(of: "**", with: totalExpense.description)
            buttonMessage = Strings.ADD_SOME_MORE_EXPENSE_MESSAGE
            buttonWidth = 260
        }
        
        let howMuchYouSpendTodayString = NSAttributedString(string: addExpsenseMessage, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                                                                                                                NSAttributedString.Key.foregroundColor : UIColor.black])
        
        // View Model 1
        let labelViewModel = LabelViewModel(alignment: .center, text: howMuchYouSpendTodayString, backgroundColor: .white, curve: topCurve)
        
        let buttonAttributedString = NSAttributedString(string: buttonMessage, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
                                                                                                                NSAttributedString.Key.foregroundColor : UIColor.white])
        
        let timeStampString = getLastUpatedTimeStamp()
        let curve : Curve = timeStampString == nil ? bottomCurve : .none
        
        // View Model 2
        let buttonModel = ButtonViewModel(text: buttonAttributedString, viewBackgroundColor: .white, buttonBackgroundColor: .blue, forgroundColor: .white, fixWidth: buttonWidth, curve: curve) { [weak self] in
            self?.showExpenseViewController()
        }
        
        cellTypes = [CellType.label(viewModel: labelViewModel),
        CellType.button(viewModel: buttonModel)]
        
        // View Model 3
        if let timeStampString = timeStampString {
            var lastUpdatedMessage = Strings.LAST_UPDATED_MESSAGE
            lastUpdatedMessage = lastUpdatedMessage.replacingOccurrences(of: "**", with: timeStampString)
            let lastUpdatedAttributedString = NSAttributedString(string: lastUpdatedMessage, attributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 12),
                                                                                                                           NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let lastUpdatedViewModel = LabelViewModel(alignment: .right, text: lastUpdatedAttributedString, backgroundColor: .white, curve: bottomCurve)
            cellTypes.append(CellType.label(viewModel: lastUpdatedViewModel))
            
        }
        return cellTypes
    }
    
    private func getTatalExpenseCard() -> [CellType] {
        
        let totalExpenseAmount = " ₹ " + getTotalExpenseOfThisMonth().description
        
        let totalExpenseString = NSAttributedString(string: Strings.TOTAL_EXPESE_MESSAGE, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                                                                                                                NSAttributedString.Key.foregroundColor : UIColor.black])
        let totalExpenseModel = LabelViewModel(alignment: .center, text: totalExpenseString, backgroundColor: .white, curve: topCurve)
        
        
        let totalExpenseAmountString = NSAttributedString(string: totalExpenseAmount, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24),
                                                                                                                NSAttributedString.Key.foregroundColor : UIColor.blue])
        let totalExpenseAmountModel = LabelViewModel(alignment: .center, text: totalExpenseAmountString, backgroundColor: .white, curve: bottomCurve)
        
     
        
        return [CellType.label(viewModel: totalExpenseModel),
                CellType.label(viewModel: totalExpenseAmountModel)]
    }
    
    private func getBarChartCell() -> [CellType] {
        let attributedString = NSAttributedString(string: Strings.BAR_CHART_MESSAGE, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
        NSAttributedString.Key.foregroundColor : UIColor.black])

        let totalExpenseModel = LabelViewModel(alignment: .center, text: attributedString, backgroundColor: .white, curve: topCurve)
        let dictionary = DataManger.getMonthlyExpense(ofLastMonths: 6)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        
        let chartData = dictionary.keys.sorted { $0 < $1 }.map { (date) -> (String, Double) in
            return (formatter.string(from: date), Double(dictionary[date] ?? 0))
        }

        let chartModel = ChartViewModel(dataPoints: chartData.map { $0.0 }, values: chartData.map { $0.1 }, backgroundColor: .blue, curve: bottomCurve)

        return [CellType.label(viewModel: totalExpenseModel),
                CellType.barChart(viewModel: chartModel)]
    }
    
    private func getTotalExpenseOfThisMonth() -> Int {
        let componants = Calendar.current.dateComponents([.month, .year], from: Date())
        
        guard let month = componants.month,
        let year = componants.year else { return 0 }
        return DataManger.getTotalExpense(ofMonth: month, andYear: year)
    }
    
    @objc private func showExpenseViewController() {
        let expenseViewModel = ExpenseViewModel(expenseAmount: nil, note: nil, categoryName: "Select", categoryTag: "--", date: Date())
        expenseController = AddExpenseViewController(model: expenseViewModel)
        expenseController?.delegate = self
        expenseController?.navigationItem.title = "Add Expense"
        presenter?.present(controller:  UINavigationController(rootViewController: expenseController!), animated: true)
    }
    
    private func getTodaysTotalExpenses() -> Int? {
        let expenses = DataManger.getTodaysExpenses()
        guard !expenses.isEmpty else { return nil }
        return expenses.reduce(0) { (result, expense) -> Int in
            return result + Int(expense.spend)
        }
    }
    
    private func getLastUpatedTimeStamp() -> String? {
        guard let timeStamp = DataManger.getLastUpdatedTimeStamp() else { return nil }
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: timeStamp, to: Date())
        
        if let year = components.year, year != 0 {
            return "\(year) year/s"
        }
        
        if let month = components.month, month != 0 {
            return "\(month) month/s"
        }
        
        if let day = components.day, day != 0  {
            return "\(day) day/s"
        }
        
        if let hour = components.hour, hour != 0 {
            return "\(hour) hour/s"
        }
        
        if let min = components.minute, min != 0 {
            return "\(min) min/s"
        }
        return "a moment ago"
    }
}

extension HomeViewManager : AddExpenseViewControllerDelegate {
    func addExpense(_ expenseModel: ExpenseViewModel) {
        DataManger.addExpense(expenseModel)
        expenseController?.dismiss(animated: true, completion: nil)
        presenter?.refresh()
    }
}
