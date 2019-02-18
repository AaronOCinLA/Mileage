//
//  ChartsViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/7/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    
    var data = [EntryHistoryChartData]()
    var max: Int = 0
    var swipedLeft = false
    
    // TODO - Delete
    @IBOutlet var testTextView: UITextView!
    
    @IBOutlet var barChart: BarChartView!
    
    var months = [String]()
    var numMiles = [Int]()
    var dataEntries: [BarChartDataEntry] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func loadMonthArray() {
        for i in -max...0 {
            months.append(Date().getMonthShortString(x: i))
        }
    }
    
    @IBAction func didSwipeLeft() {
        swipedLeft = true
    }
    
    func setChart() {
        
        numMiles = numMiles.reversed()
        for i in 0...max {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(numMiles[i]))
            dataEntries.append(dataEntry)
        }
        
        if (swipedLeft){
            // change to monies
            dataEntries.removeAll()
            for i in 0...max {
                dataEntries = [BarChartDataEntry(x: Double(i), y: Double(data[i].getTotalMilesForMonth()))]
            }
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Months")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChart.data = chartData
    }
    
    // MARK: - Navigation

}
