//
//  BarChartViewCell.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 03/11/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit
import Charts

struct ChartViewModel : ViewModel {
    var dataPoints: [String]
    var values: [Double]
    var backgroundColor : UIColor
    
    var curve : Curve
}

class BarChartViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    
    var viewModel: ChartViewModel? {
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
                bottomContainerConstraint.constant = 0
            case .bottom(let radius, let margin):
                containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
                topContainerConstraint.constant = 0
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
    
    private func setupModel(model: ChartViewModel?) {
        if let model = model {
            setBarChart(dataPoints: model.dataPoints, values: model.values)
            curve = model.curve
            backgroundColor = .clear
        } else {
            cleanCell()
        }
    }
    
    private func cleanCell() {
        
    }
    
    private func setBarChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.stackLabels = dataPoints
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.fitBars = true
        
        barChartView.noDataText = ""
        barChartView.setVisibleXRangeMaximum(10)
        chartDataSet.colors = ChartColorTemplates.colorful()
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 0
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
    }
    
}
