//
//  ViewControllerOptions.swift
//  Mileage
//
//  Created by Aaron O'Connor on 12/21/17.
//  Copyright © 2017 Aaron O'Connor. All rights reserved.
//

import UIKit
import MessageUI

// To do: Prompt to save and clear at the beginning of the month

let fileName = "Test"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")


class ViewControllerOptions: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    var destination = Destination()
    
    let momsEmail = "tclaudia06@gmail.com" // "aaronoc76@gmail.com"
    var csvHeader = ""
    let arrCSVHeader = ["Date", "Start Mileage", "End Mileage", "Total Mileage", "Cost/Gal", "COST", "Destination"]
    
    var arrTitles = ["Clear History", "Add Destination City", "Email Report"]
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = arrTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        // let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        // let currentItem = currentCell.textLabel!.text
        let currRow = indexPath!.row
        
        switch currRow {
        case 0:
            let alert = UIAlertController(title: "Clear History", message: "Are you sure you want to delete the history?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alert: UIAlertAction!) -> Void in
                
                // Delete cached data
                data.removeAll()
                NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
                //print("You pressed Cancel")
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            present(alert, animated: true, completion:nil)
            
            
            
        case 1:
            
            let alertController = UIAlertController(title: "New City", message: "Please input your new destination:", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                if let newCity = alertController.textFields![0] as UITextField? {
                    // store your data
                    
                    if newCity.text != "" {
                        self.destination.city.insert(newCity.text!, at: self.destination.city.count - 1)
                        userDefaults.set(self.destination.city, forKey: "arrDestinations")
                    }
                } else {
                    // user did not fill field
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Some city you visit a lot"
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        case 2:
            
            // email report
            if (data.count < 1) {
                showMailError()
            }
            else {
                
                let mailComposeViewController = configureMailController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                }
                else {
                    showMailError()
                }
            }
        // Call email
        default:
            print("No data to send.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get month and year for strings
        var curDate = Date()
        if (data.count > 0) {
            curDate = data[0]._date
        }
        let year = Calendar.current.component(.year, from: curDate)
        let dateMonth  = curDate.monthMedium  // "May"
        strThisMonth = "\(dateMonth)"
        strThisYear = "\(year)"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMailController() -> MFMailComposeViewController {
        
        // Create Attachment
        let lastDateEntry = data[data.count-1]._strDate
        let writeString = createCSVString()
        
        // string is created, now write file
        do {
            // Write to file
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed to write the URL ")
            print(error)
        }
        
        // Create Email
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([momsEmail])
        mailComposerVC.setSubject("Mileage Report: \(lastDateEntry)")
        mailComposerVC.setSubject("Mileage Report: \(strThisMonth) \(strThisYear)")
        mailComposerVC.setMessageBody("Attached is a copy of your mileage report for \(strThisMonth) \(strThisYear).", isHTML: false)
        
        
        // Add attachment
        if let data = NSData(contentsOfFile: fileURL.path) {
            mailComposerVC.addAttachmentData(data as Data, mimeType: "text/comma-separated-values", fileName: "Mileage\(strThisMonth)\(strThisYear).csv")
            
            present(mailComposerVC, animated: true, completion: nil)
        } else {
            NSLog("No data")
        }
        
        return mailComposerVC
    }
    
    func showMailError () {
        
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send the email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // Closes mail app, otherwise it stays open.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func createCSVString() -> String {
        var writeString = ""
        var strCostPerGal = ""
        var strCost = ""
        var strTotalCost = ""
        
        csvHeader = ("\t\(strThisMonth) \t\t\(strThisYear) \t\t2012 Buick LaCross\n")
        
        // Get CSV Header
        writeString = csvHeader
        
        // Get CSV Column variables
        for i in 0 ... (arrCSVHeader.count-1) {
            writeString = writeString + (arrCSVHeader[i] + ",")
        }
        
        
        writeString = writeString + ("\n")
        
        totalCost = 0.0
        //totalMiles = (Int(data[data.count-1]._eMileage)! - Int(data[0]._sMileage)!) // Get total miles
        totalMiles = data[0].getTotalMiles()
        
        
        // Get date for each row
        for i in 0 ... (data.count-1) {
            
            if (data[i]._pricePerGallon.count > 0) {
                strCostPerGal = String(format: "%.02f", (Double(data[i]._pricePerGallon))!)
            }
            if (data[i]._tSale.count > 0) {
                strCost = String(format: "%.02f", (Double(data[i]._tSale))!)
            }
            
            writeString = writeString + (data[i]._strDate + ",")
            writeString = writeString + (data[i]._sMileage + ",")
            writeString = writeString + (data[i]._eMileage + ",")
            writeString = writeString + (data[i]._tMileage + ",")
            if (data[i]._tSale != "") {
                totalCost = totalCost + Double(data[i]._tSale)!  // Increment total cost spent on gas
            }
            writeString = writeString + ("\(strCostPerGal),")
            writeString = writeString + ("\(strCost),")
            writeString = writeString + (data[i]._destination + "\n")
        }
        
        strTotalCost = String(format: "%.02f", totalCost)
        writeString = writeString + ",,,Total Miles: \(totalMiles),,Total Spent: $\(strTotalCost),\n"
        
        return writeString
    }
    
}
