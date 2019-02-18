//
//  ChartsContentViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/8/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ChartsContentViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    enum reportType: Int {
        case miles, gasSpent
    }
    var index = 0
    
    let userDefault = UserDefaults.standard
    var fetchResultController: NSFetchedResultsController<MileageEntryMO>!
    
    var entry: MileageEntryMO!
    var entries: [MileageEntryMO] = []
    var months = [String]()
    
    var numMiles = [Int]()
    var monthlyTotalGasSpent = [Double]()
    
    var data: [EntryHistoryChartData] = []
    var dataEntries: [BarChartDataEntry] = []
    let maxMonths = 6
    
    @IBOutlet var barChart: BarChartView!
    
    @IBOutlet var chartTitleLable: UILabel! {
        didSet {
            chartTitleLable.numberOfLines = 0
        }
    }
    
    @IBOutlet var contentUIView: UIView!
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        getMileageHistory()
        createDataArray()
        getMileageHistory()
        loadMonthArray()
        
        
        barChart.chartDescription?.text = ""
        barChart.noDataText = "No Data to show yet"
        setChart()
    }
    
    @IBAction func didTapNext(sender: UIButton) {

        index = (index + 1)%2
        setChart()
        self.viewDidLoad()
    }
    
    // Fetch data from data store
    func fetchData() {
        
        let fetchRequest: NSFetchRequest<MileageEntryMO> = MileageEntryMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    entries = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    func createDataArray() {
        
        for i in 0...data.count - 1 {
            
            if let tlGas = Double(data[i].totalGas!.gasPriceFormat()) {
                monthlyTotalGasSpent.append(tlGas)
            }
            let tlMiles = data[i].getTotalMilesForMonth()
            numMiles.append(tlMiles)
        }
    }
    
    func loadMonthArray() {
        for i in -data.count + 1 ... 0 {
            months.append(Date().getMonthShortString(x: i))
        }
    }
    
    func setChart() {
        
        if let reportSelection = reportType(rawValue: index) {
            switch reportSelection {
            case .miles:
                
                chartTitleLable.text = "Monthly Miles Report"
                numMiles = numMiles.reversed()
                for i in 0...data.count - 1 {
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(numMiles[i]))
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "Months")
                let chartData = BarChartData(dataSet: chartDataSet)
                
                barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
                barChart.data = chartData
                
            case .gasSpent:
                
                dataEntries.removeAll()
                
                monthlyTotalGasSpent = monthlyTotalGasSpent.reversed()
                chartTitleLable.text = "Total Spent for Gas"
                for i in 0...data.count - 1 {
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(monthlyTotalGasSpent[i]))
                    dataEntries.append(dataEntry)
                }
                
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "Months")
                let chartData = BarChartData(dataSet: chartDataSet)
           
                barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
                barChart.data = chartData
            }
        }
        
        barChart.backgroundColor = .white
        barChart.xAxis.labelPosition = .bottom

    }
    
    
    func getMileageHistory() {
        
        data.removeAll()
        for _ in 0...maxMonths {
            data.append(EntryHistoryChartData())
        }
        
        for i in 0...entries.count - 1 {
            let c = entries[i].date!.getDifferenceOfMonths() //
            data[c].odometerEntries.append(Int(entries[i].odometer))
            if let daTotalGas = data[c].totalGas {
                data[c].totalGas = daTotalGas + entries[i].totalSale
            }
        }
    }
}
