//
//  ChartsContentViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/8/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit
import Charts

class ChartsContentViewController: UIViewController {
    
    
    let maxMonths = 6
    var data = [EntryHistoryChartData]()
    var max: Int = 0
    let citiesArray = ["Destination", "Las Vegas", "North Hills", "Redlands", "San Bernardino", "San Diego", "29 Palms", "Crazy"]
    var entry = MileageEntry()
    var entryArray: [MileageEntry] = []
    var months = [String]()
    var numMiles = [Int]()
    var dataEntries: [BarChartDataEntry] = []
    
    

    @IBOutlet var barChart: BarChartView!
    
    @IBOutlet var chartTitleLable: UILabel! {
        didSet {
            chartTitleLable.numberOfLines = 0
        }
    }
    
    @IBOutlet var contentUIView: UIView!
    
    var index = 0
    var chartTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartTitleLable.text = chartTitle
        
        
        for i in 0...max {
            let tlGas = data[i].totalGas!.gasPriceFormat()
            let tlMiles = data[i].getTotalMilesForMonth()
            let destArr = data[i].getDestinationVisitCount()
            numMiles.append(tlMiles)
        }
        
        createTestArray()
        getMileageHistory()
        max = data.count - 1
        loadMonthArray()
        
        
        barChart.chartDescription?.text = ""
        barChart.noDataText = "No Data to show yet"
        setChart()
    }
    
    // TODO: Remove this
    func createTestArray() {
        
        let max = 60
        for i in 1...max {
            var testDate = Date()
            let testOdometer = 24601
            testDate = testDate.addingTimeInterval(Double(-i*3)*60*60*24)
            entryArray.append(MileageEntry(date: testDate, odometer: (testOdometer - i*43), totalSale: 21.32, pricePerGallon: 3.749, destination: citiesArray[i%citiesArray.count]))
        }
    }
    
    func loadMonthArray() {
        for i in -max...0 {
            months.append(Date().getMonthShortString(x: i))
        }
    }
    
    func setChart() {
        
        numMiles = numMiles.reversed()
        for i in 0...max {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(numMiles[i]))
            dataEntries.append(dataEntry)
        }
        
        func getMileageHistory() {
            data.removeAll()
            for _ in 0...maxMonths {
                data.append(EntryHistoryChartData())
            }
            
            for i in 0...entryArray.count - 1 {
                let c = entryArray[i].date.getDifferenceOfMonths() //
                data[c].odometerEntries.append(entryArray[i].odometer)
                if let daTotalGas = data[c].totalGas {
                    data[c].totalGas = daTotalGas + entryArray[i].totalSale
                }
                if (entryArray[i].destination != "") {
                    data[c].destinationArray?.append(entryArray[i].destination)
                }
            }
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Months")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChart.data = chartData
    }
    
    
    func getMileageHistory() {
        data.removeAll()
        for _ in 0...maxMonths {
            data.append(EntryHistoryChartData())
        }
        
        for i in 0...entryArray.count - 1 {
            let c = entryArray[i].date.getDifferenceOfMonths() //
            data[c].odometerEntries.append(entryArray[i].odometer)
            if let daTotalGas = data[c].totalGas {
                data[c].totalGas = daTotalGas + entryArray[i].totalSale
            }
            if (entryArray[i].destination != "") {
                data[c].destinationArray?.append(entryArray[i].destination)
            }
        }
    }
}
