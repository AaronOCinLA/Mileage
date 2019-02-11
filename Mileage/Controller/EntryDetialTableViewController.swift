//
//  EntryDetialTableViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/4/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit

class EntryDetialTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    let userDefault = UserDefaults.standard
    
    
    var cityArray = [String]()
    
    var lastEnteredGasPrice = 3.749
    var gasPriceArray = [Double]()
    var selectedGasPrice = 0.0
    
    enum sectionName: Int {
        case date, gas, odometer, destination, entryPreview
    }
    
    enum uiPicker: Int {
        case gallonPrice, destination
    }
    
    
    var today = Date()
    var newDate = Date()
    var lastOdomterEntry = 30127
    
    var entry = MileageEntry()
    
    @IBOutlet weak var dateStepper: UIStepper!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startMilesLabel: UILabel!
    
    @IBOutlet weak var odometerTextField: UITextField!
    @IBOutlet weak var totalSaleTextField: UITextField!
    
    @IBOutlet weak var previewDateLabel: UILabel!
    @IBOutlet weak var previewDestinationLabel: UILabel!
    @IBOutlet weak var previewTotalSale: UILabel!
    @IBOutlet weak var previewPricePerGallon: UILabel!
    
    @IBOutlet weak var updateGasPrice: UIPickerView!
    @IBOutlet weak var updateDestination: UIPickerView!
    
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
    
    @IBAction func clickSubmit(_ sender: Any) {
        let newEntry = MileageEntry.init(date: newDate, odometer: Int(odometerTextField.text!)!, totalSale: Double(totalSaleTextField.text!)!, pricePerGallon: selectedGasPrice, destination: previewDestinationLabel.text!)
        
        entry = newEntry
    }
    
    func printEntry (entry: MileageEntry) {
        print("\nDate: " + entry.date.dateToString)
        print("Odometer: " + String(entry.odometer))
        print("Destination: " + entry.destination)
    }
    
    
    @IBAction func updateOdometer(_ sender: Any) {
        
        if odometerTextField.text != "" {
            lastOdomterEntry = Int(odometerTextField.text!)!
            startMilesLabel.text = String(lastOdomterEntry)
        }
    }
    
    @IBAction func updateTotalSale(_ sender: Any) {
        previewTotalSale.text = "$" + totalSaleTextField.text!
    }
    
    
    func updateLabels() {
        dateLabel.text = newDate.dateToString
        previewDateLabel.text = newDate.dateToString
        odometerTextField.placeholder = String(lastOdomterEntry)
    }
    
    // MARK: - Viewcontrol Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateGasPrice.selectRow(50, inComponent:0, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cityArray = loadCityArray()
        
        // Create gas price array
        for i in -50...50 {
            let x = Double(i)/100.0 + lastEnteredGasPrice
            gasPriceArray.append(x)
        }
        
        updateLabels()
        
        self.updateDestination.delegate = self
        self.updateDestination.dataSource = self
        
        self.updateGasPrice.delegate = self
        self.updateGasPrice.dataSource = self
    }
    
    
    func loadCityArray() -> [String] {
        if let constantName = userDefault.value(forKey: "cityArray") {
            return constantName as! [String]
        } else { return [String]() }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellSection = sectionName(rawValue: section) {
            switch cellSection {
            case .gas:
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
        
        if let pickerViewSelection = uiPicker(rawValue: pickerView.tag) {
            switch pickerViewSelection {
            case .destination:
                return cityArray.count
            case .gallonPrice:
                return gasPriceArray.count
            }
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let pickerViewSelection = uiPicker(rawValue: pickerView.tag) {
            switch pickerViewSelection {
            case .destination:
                return cityArray[row]
            case .gallonPrice:
                return String(gasPriceArray[row].gasPriceFormat())
            }
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let pickerViewSelection  = uiPicker(rawValue: pickerView.tag) {
            switch pickerViewSelection {
            case .destination:
                previewDestinationLabel.text = cityArray[row]
            case .gallonPrice:
                selectedGasPrice = gasPriceArray[row]
                previewPricePerGallon.text = "$" + String(gasPriceArray[row].gasPriceFormat())
            }
        }
    }
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitToAllEntriesSegue" {
            let destinationController = segue.destination as! EntriesTableViewController
            destinationController.entry = entry
        }
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("Unwinding ... ")
    }
}
