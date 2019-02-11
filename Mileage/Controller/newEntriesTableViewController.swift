//
//  newEntriesTableViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/10/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit

class newEntriesTableViewController: UITableViewController {
    
    let userDefault = UserDefaults.standard
    
    
    let maxMonths = 6
    var entry = MileageEntry()
    var dataArray = [EntryHistoryChartData]()
    var entryArray: [MileageEntry] = []  // Remove this
    var cityArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cityArray = loadCityArray()
        createTestArray()           // TODO: Delete
    }
    
    // MARK: - Functions
    
    func loadCityArray() -> [String] {
        if let constantName = userDefault.value(forKey: "cityArray") {
            return constantName as! [String]
        } else { return [String]() }
    }
    
    // TODO: Remove this
    func createTestArray() {
        
        let max = 60
        for i in 1...max {
            var testDate = Date()
            let testOdometer = 24601
            testDate = testDate.addingTimeInterval(Double(-i*3)*60*60*24)
            
            var tempCityName = ""
            
            if (cityArray.count > 0)  {
                tempCityName = cityArray[i%cityArray.count]
            }
            
            entryArray.append(MileageEntry(date: testDate,
                                           odometer: (testOdometer - i*43),
                                           totalSale: 21.32,
                                           pricePerGallon: 3.749,
                                           destination: tempCityName))
        }
    }
    
    func getMileageHistory() {
        dataArray.removeAll()
        for _ in 0...maxMonths {
            dataArray.append(EntryHistoryChartData())
        }
        
        for i in 0...entryArray.count - 1 {
            let c = entryArray[i].date.getDifferenceOfMonths() //
            dataArray[c].odometerEntries.append(entryArray[i].odometer)
            if let daTotalGas = dataArray[c].totalGas {
                dataArray[c].totalGas = daTotalGas + entryArray[i].totalSale
            }
            if (entryArray[i].destination != "") {
                dataArray[c].destinationArray?.append(entryArray[i].destination)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "entryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        cell.lblDate.text = "Date: " + entryArray[indexPath.row].date.dateToString
        cell.lblSMileage.text = "Start: " + String(entryArray[indexPath.row].odometer-43)
        cell.lblEMileage.text = " End: " + String(entryArray[indexPath.row].odometer)
        //        cell.lblTMileage.text = "Total Miles: 43"
        cell.lblDestination.text = "Destination: \(entryArray[indexPath.row].destination)"
        cell.lbltSale.text = "$" + entryArray[indexPath.row].totalSale.gasPriceFormat()
        cell.lblMpg.text = "$" + entryArray[indexPath.row].pricePerGallon.gasPriceFormat()
        
        //        cell.imageGas.image = UIImage(named: "gasTank")
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataToChartsSegue" {
            let destinationController = segue.destination as! ChartsViewController
            getMileageHistory()
            destinationController.data = dataArray
        } else if segue.identifier == "addNewEntrySegue" {
            let destinationController = segue.destination as! EntryDetialTableViewController
            destinationController.hidesBottomBarWhenPushed = true
        }
        
    }
}
