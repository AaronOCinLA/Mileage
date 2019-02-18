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
    
    var lastOdometerEntry = 0
    
    let maxMonths = 6
    var entry = MileageEntry()
    var dataArray = [EntryHistoryChartData]()
    var entryArray: [MileageEntryMO] = []  // Remove this
    var newEntry: MileageEntryMO!
    
    // Core data
    var entries: [MileageEntryMO] = []
    var entryMO: MileageEntryMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //             createTestArray() // TODO: Delete
        fetchData()
    }
    
    // MARK: - Functions
    
    func fetchData() {
        
        let fetchRequest: NSFetchRequest<MileageEntryMO> = MileageEntryMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    entries = fetchedObjects
                    userDefault.set(Int(entries[0].odometer), forKey: "odometer")
                }
            } catch {
                print(error)
            }
        }
    }
    
    // TODO: Remove this test data generator
    func createTestArray() {
        
        let max = 60
        for i in 1...max {
            var testDate = Date()
            let testOdometer = 24601
            
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                testDate = testDate.addingTimeInterval(Double(-i*3)*60*60*24)
                
                entryMO = MileageEntryMO(context: appDelegate.persistentContainer.viewContext)
                entryMO.date = testDate
                entryMO.startOdometer = Int16(testOdometer - i*43)
                entryMO.odometer = entryMO.startOdometer + 43
                entryMO.totalSale = 21.32
                entryMO.note = ""
                
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
                self.entries[indexPath.row-1].startOdometer = self.entries[indexPath.row+1].odometer
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
        cell.lblSMileage.text = "Start: " + String(entries[indexPath.row].startOdometer)
        cell.lblEMileage.text = " End: " + String(entries[indexPath.row].odometer)
        cell.lblTMileage.text = "Total Miles: \(entries[indexPath.row].odometer - entries[indexPath.row].startOdometer)"
        cell.lbltSale.text = "$" + entries[indexPath.row].totalSale.gasPriceFormat()
        cell.lblMpg.text = "$" + entries[indexPath.row].pricePerGallon.gasPriceFormat()
        
        //        cell.imageGas.image = UIImage(named: "gasTank")
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let entryToDelete = self.fetchResultController.object(at: indexPath)
                
                
                if (indexPath.row == 0) {
                    print("Error: cannot delete top row")
                    tableView.reloadData()
                }
                else if indexPath.row == self.entries.count - 1 {
                    print("Error: cannot delete bottom row")
                    tableView.reloadData()
                }
                else {
                    context.delete(entryToDelete)
                    appDelegate.saveContext()
                    //                    tableView.reloadData()
                }
            }
            
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler)
            in
            
            //            let activityController: UIActivityViewController
            
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeConfiguration
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataToChartsSegue" {
            let destinationController = segue.destination as! ChartsViewController
            destinationController.data = dataArray
        } else if segue.identifier == "addNewEntrySegue" {
            let destinationController = segue.destination as! EntryDetialTableViewController
            destinationController.hidesBottomBarWhenPushed = true
            
            //            destinationController.lastOdomterEntry = self.lastOdometerEntry
            // Get most recent odometer entry
            
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
