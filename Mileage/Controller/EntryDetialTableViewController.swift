//
//  EntryDetialTableViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/4/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit
import CoreData

class EntryDetialTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    let userDefault = UserDefaults.standard
    var entry: MileageEntryMO!
    var selectedGasPrice = 0.0
    
    var lastEnteredGasPrice = 0.0
    
    var gasPriceArray = [Double]()
    
    enum sectionName: Int {
        case date, gas, odometer, entryPreview
    }
    
    var today = Date()
    var newDate = Date()
//    var lastOdomterEntry = 30127
    
    @IBOutlet weak var dateStepper: UIStepper!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startMilesLabel: UILabel!
    
    @IBOutlet weak var odometerTextField: UITextField!
    @IBOutlet weak var totalSaleTextField: UITextField!
    
    @IBOutlet weak var previewDateLabel: UILabel!
    @IBOutlet weak var previewTotalSale: UILabel!
    @IBOutlet weak var previewPricePerGallon: UILabel!
    
    @IBOutlet weak var updateGasPrice: UIPickerView!
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 15
        }
    }
    
    
    // MARK: - Methods
    
    @IBAction func dateStepper(_ sender: Any) {
        let secondsPerDay = Double(60 * 60 * 24)
        newDate = today.addingTimeInterval(dateStepper.value * secondsPerDay)
        updateLabels()
    }
    
    
    
    @IBAction func updateOdometer(_ sender: Any) {
        
        
        // Check if valid
        if let odometer = odometerTextField.text {
//            if (Int(odometer)! < lastOdomterEntry) {
//                print("Error: odometer entry must be greater than \(lastOdomterEntry)")
//            }
        }
    }
    
    @IBAction func updateTotalSale(_ sender: Any) {
        previewTotalSale.text = "$" + totalSaleTextField.text!
    }
    
    
    func updateLabels() {
        dateLabel.text = newDate.dateToString
        previewDateLabel.text = newDate.dateToString
        if let lastOdometerEntry = userDefault.value(forKey: "odometer") {
            odometerTextField.placeholder = String(lastOdometerEntry as! Int16)
        }
    }
    
    // MARK: - Viewcontrol Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateGasPrice.selectRow(50, inComponent:0, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // userDefault.set(24601, forKey: "odometer")
        
        
        if let lastOdometerEntry = userDefault.value(forKey: "odometer") {
            odometerTextField.text = lastOdometerEntry as? String
        }
        
        // Load cached gas price
        if let cachedGasPrice = userDefault.value(forKey: "lastGasPrice") {
            lastEnteredGasPrice = cachedGasPrice as? Double ?? 3.749
        } else {
            lastEnteredGasPrice = 3.749
        }
        
        // Create gas price array
        for i in -50...50 {
            let x = Double(i)/100.0 + lastEnteredGasPrice
            gasPriceArray.append(x)
        }
        
        updateLabels()
        
        self.updateGasPrice.delegate = self
        self.updateGasPrice.dataSource = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellSection = sectionName(rawValue: section) {
            switch cellSection {
            case .gas:
                return 2
            case .entryPreview:
                return 2
            default:
                return 1
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    // UIPickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gasPriceArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //  entry.pricePerGallon = Double(gasPriceArray[row].gasPriceFormat())!
        return String(gasPriceArray[row].gasPriceFormat())
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedGasPrice = gasPriceArray[row]
        previewPricePerGallon.text = "$" + String(gasPriceArray[row].gasPriceFormat())
    }
    
    // MARK: - Navigations/Submit New Entry
    
    
    @IBAction func clickSubmit(sender: AnyObject) {
        
        // Error check
        var odom = Int16(0)
        let lastEntry = userDefault.value(forKey: "odometer") as! Int16
        if let odometerText = odometerTextField.text {
            if let odometerInt = Int16(odometerText) {
                odom = odometerInt
            } else {
                print("Must be number.")
            }
        }
        if (odom < lastEntry) {
            
            let alertController = UIAlertController(title: "Odometer Entry Error", message: "The odometer entry must be a valid number, greater than \(lastEntry)", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            
            return
        } else {
            // Save entry and return to main VC
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                var entryMO: MileageEntryMO!
                entryMO = MileageEntryMO(context: appDelegate.persistentContainer.viewContext)
                entryMO.date = Date() // update this to match label
                entryMO.startOdometer = lastEntry
                entryMO.odometer = odom
                if let totalSaleDouble = totalSaleTextField.text {
                    entryMO.totalSale = Double(totalSaleDouble)!
                }
                entryMO.note = ""
                
                appDelegate.saveContext()
                
                // Segue unwind
                performSegue(withIdentifier: "unwindHome", sender: nil)
                
            }
            
        }
        
        
//        if (odometerTextField.text == "1") {
//
//            let alertController = UIAlertController(title: "Odometer Entry Error", message: "The odometer entry must be a valud number", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(alertAction)
//            present(alertController, animated: true)
//
//            return
//        }
        
//        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//            entry = MileageEntryMO(context: appDelegate.persistentContainer.viewContext)
//            entry.date = Date()
//            entry.pricePerGallon = selectedGasPrice
//            if let amount = totalSaleTextField.text {
//                entry.totalSale = Double(amount)!
//            }
//            if let odmeterReading = odometerTextField.text {
//                entry.odometer = Int16(odmeterReading)!
//                userDefault.set(entry.pricePerGallon, forKey: "lastGasPrice")
//            }
//
//            appDelegate.saveContext()
//        }
        dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: "returnToHome", sender:)
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
//        if odometerTextField.text == "1" {
//            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(alertAction)
//            present(alertController, animated: true, completion: nil)
//            
//            return
//        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
