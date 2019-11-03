//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit
import Charts

class CardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var categoryController : ListingViewController?
    private var expenseController : AddExpenseViewController?
    private var cardProtocol : CardProtocol
    private var cellTypes : [CellType] = []
    
    private var attributes : [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    init(cardProtocol: CardProtocol) {
        self.cardProtocol = cardProtocol
        super.init(nibName: nil, bundle: nil)
        self.cardProtocol.presenter = self
    }
    
    required init?(coder: NSCoder) {
        self.cardProtocol = HomeViewManager()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCards()
        setupNavbar()
        setupToolbar()
        setupTableView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCards()
    }
    
    private func setupCards() {
        cellTypes = cardProtocol.getCards()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        registerCells()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellTypes[indexPath.row].getCell(tableView: tableView)
        cell?.layoutIfNeeded()
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    private func setupNavbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Track Expense"
    }
    
    private func registerCells() {
        cellTypes.forEach { $0.register(for: tableView) }
    }

    @objc private func addButtonTapped() {
        let expenseViewModel = ExpenseViewModel(expenseAmount: nil, note: nil, categoryName: "Select", categoryTag: "--", date: Date())
        expenseController = AddExpenseViewController(model: expenseViewModel)
        expenseController?.delegate = self
        expenseController?.navigationItem.title = "Add Expense"
        present(UINavigationController(rootViewController: expenseController!) , animated: true, completion: nil)
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        let historyButton = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(historyButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [spacer, historyButton]
        view.addSubview(toolbar)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toolbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        if let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
        toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom).isActive = true
        }
    }
    
    @objc private func historyButtonTapped() {
        let historyViewController = HistoryViewController()
        let navigationController = UINavigationController(rootViewController: historyViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension CardViewController : AddExpenseViewControllerDelegate {
    func addExpense(_ expenseModel: ExpenseViewModel) {
        DataManger.addExpense(expenseModel)
        expenseController?.dismiss(animated: true, completion: nil)
    }
}

extension CardViewController : PresentationProtocol {
    func refresh() {
        setupCards()
    }
    
    func present(controller: UIViewController, animated: Bool) {
        present(controller, animated: animated)
    }
}

//    private func setBarChart(dataPoints: [String], values: [Double]) {
//        barChartView.noDataText = "You need to provide data for the chart."
//        var dataEntries: [BarChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
//            dataEntries.append(dataEntry)
//        }
//
//        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
//
//
//        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Total expense")
//        chartDataSet.stackLabels = dataPoints
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barChartView.data = chartData
//
//        barChartView.noDataText = ""
//        barChartView.setVisibleXRangeMaximum(10)
//        chartDataSet.colors = ChartColorTemplates.colorful()
//
//        barChartView.xAxis.labelPosition = .bottom
//        barChartView.xAxis.granularity = 0
//
//        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
//    }
//
//    private func setPieChart(dataPoints: [String], values: [Double]) {
//        pieChartView.noDataText = "You need to provide data for the chart."
//        var dataEntries: [PieChartDataEntry] = []
//
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
//            dataEntries.append(dataEntry)
//        }
//
//        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "Total expense")
//        let chartData = PieChartData(dataSet: chartDataSet)
//        pieChartView.data = chartData
//
//        pieChartView.noDataText = ""
//        chartDataSet.colors = ChartColorTemplates.colorful()
//
//        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 0.0, easingOption: .easeInBounce)
//    }
    
        
//        let dictionary = DataManger.getMonthsExpense()
//        let months = dictionary.keys.map { $0 }
//        let totalExpenses = dictionary.values.map { Double($0) }
//
////        setBarChart(dataPoints: months, values: totalExpenses)
//        setBarChart(dataPoints: ["JAN", "FAB", "MAR", "APR", "MAY", "JUN"], values: [1000, 5000, 1250, 1000, 5000, 1250])
//        setPieChart(dataPoints: ["JAN", "FAB", "MAR", "APR", "MAY", "JUN"], values: [1000, 5000, 1250, 1000, 5000, 1250])
