//
//  newEntriesTableViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/10/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let userDefault = UserDefaults.standard
    var fetchResultController: NSFetchedResultsController<MileageEntryMO>!
    
    var deleteAllCoreData = false
    
    let maxMonths = 6
    var entry = MileageEntry()
    var dataArray = [EntryHistoryChartData]()
    var entryArray: [MileageEntryMO] = []  // Remove this
    var cityArray = [String]()
    
    // Core data
    var entries: [MileageEntryMO] = []
    var entryMO: MileageEntryMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        cityArray = loadCityArray()
//        createTestArray() // TODO: Delete
        fetchData()
    }
    
    // MARK: - Functions
    
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
                    print("Number of entries: \(entries.count)")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func loadCityArray() -> [String] {
        if let constantName = userDefault.value(forKey: "cityArray") {
            return constantName as! [String]
        } else { return [String]() }
    }
    
    func deleteCoreData() {
        print("delete Core Data")
    }
    
    // TODO: Remove this test data generator
    func createTestArray() {
        
        let max = 60
        for i in 1...max {
            var testDate = Date()
            let testOdometer = 24601
            
            var tempCityName = ""
            
            if (cityArray.count > 0)  {
                tempCityName = cityArray[i%cityArray.count]
            }
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                testDate = testDate.addingTimeInterval(Double(-i*3)*60*60*24)
                
                entryMO = MileageEntryMO(context: appDelegate.persistentContainer.viewContext)
                entryMO.date = testDate
                entryMO.odometer = Int16(testOdometer - i*43)
                entryMO.totalSale = 21.32
                entryMO.destination = tempCityName
                
                appDelegate.saveContext()
            }
        }
    }
    
    // MARK: - Table view data source
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            entries = fetchedObjects as! [MileageEntryMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "entryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        cell.lblDate.text = "Date: "
        if let cellDate = entries[indexPath.row].date {
            cell.lblDate.text = "Date: " + cellDate.dateToString
        }
        //        cell.lblDate.text = "Date: " + entryArray[indexPath.row].date.dateToString
        cell.lblSMileage.text = "Start: " + String(entries[indexPath.row].odometer-43)
        cell.lblEMileage.text = " End: " + String(entries[indexPath.row].odometer)
        cell.lblTMileage.text = "Total Miles: 43"
        cell.lblDestination.text = "Destination:"
        if let destination = entries[indexPath.row].destination {
            cell.lblDestination.text = "Destination: \(destination)"
        }
        cell.lbltSale.text = "$" + entries[indexPath.row].totalSale.gasPriceFormat()
        cell.lblMpg.text = "$" + entries[indexPath.row].pricePerGallon.gasPriceFormat()
        
        //        cell.imageGas.image = UIImage(named: "gasTank")
        
        if (deleteAllCoreData) {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let entryToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(entryToDelete)
                
                appDelegate.saveContext()
            }
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let entryToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(entryToDelete)
                
                appDelegate.saveContext()
            }
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler)
            in
            
            let activityController: UIActivityViewController
            
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        
        
        return swipeConfiguration
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataToChartsSegue" {
            let destinationController = segue.destination as! ChartsViewController
            //            getMileageHistory()
            destinationController.data = dataArray
        } else if segue.identifier == "addNewEntrySegue" {
            let destinationController = segue.destination as! EntryDetialTableViewController
            destinationController.hidesBottomBarWhenPushed = true
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}
