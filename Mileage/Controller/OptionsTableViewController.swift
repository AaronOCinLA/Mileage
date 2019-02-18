//
//  OptionsTableViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/12/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit
import CoreData

class OptionsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    let userDefault = UserDefaults.standard
    var fetchResultController: NSFetchedResultsController<MileageEntryMO>!
    
    // Core data
    var entries: [MileageEntryMO] = []
    var entryMO: MileageEntryMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func didTapReset(sender: UIButton) {
        // Show warning
        
        let alertController = UIAlertController(title: "Warning: ", message: "Are you sure you want to delete all application data?", preferredStyle: .alert)
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAlertAction)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("Deleting all history")
            self.deleteAllEntries()
        })
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
    
    @IBAction func didTapEmailData(sender: UIButton) {
        print("Emailing data to self")
    }
    
    func deleteAllEntries() {
        //         Delete: Updatae start odometer
        let fetchRequest: NSFetchRequest<MileageEntryMO> = MileageEntryMO.fetchRequest()
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            let objects = try! context.fetch(fetchRequest)
            for obj in objects {
                print("Count: \(objects.count)")
                context.delete(obj)
                appDelegate.saveContext()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
