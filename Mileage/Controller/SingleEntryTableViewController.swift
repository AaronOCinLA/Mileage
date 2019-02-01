//
//  SingleEntryTableViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 1/4/18.
//  Copyright © 2018 Aaron O'Connor. All rights reserved.
//

import UIKit

// Global variables
var data = [MileageEntry]()
var dataSettings = UserSettings()
var odometer = ""
var testMode = true
var strThisMonth = ""
var strThisYear = ""

// Create instance of user defaults
let userDefaults = UserDefaults.standard

// This creates the filePath for the persistent data
var filePath: String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first;
    
    return url!.appendingPathComponent("Data").path;
}


class SingleEntryTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Local Variables
    var destination = Destination()
    var tempEntry = MileageEntry()
    var tempSettings = UserSettings()
    let numberToolbar: UIToolbar = UIToolbar()
    var dateString = ""
    var gasPrice = ""
    var gasIndex = 0
    var strPrice = ""
    var strOdometer = ""
    let today = Date()
    var selectedDate = Date()
    var tempDate = NSDate()
    var prices = [250]
    
    
    // Labels
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDestination: UILabel!
    @IBOutlet var lblStartMiles: UILabel!
    @IBOutlet var lblEndMiles: UILabel!
    @IBOutlet var lblDateStepper: UILabel!
    @IBOutlet var lblTotalMiles: UILabel!
    @IBOutlet var lblTotalSale: UILabel!
    @IBOutlet var lblCostPerGal: UILabel!
    @IBOutlet var txtTotalSale: UITextField!
    @IBOutlet var txtOdometer: UITextField!
    
    @IBOutlet var cellDate: UITableViewCell!
    @IBOutlet var cellGas1: UITableViewCell!
    @IBOutlet var cellGas2: UITableViewCell!
    @IBOutlet var cellOdometer: UITableViewCell!
    @IBOutlet var cellDestination: UITableViewCell!
    @IBOutlet var cellCurrentEntry1: UITableViewCell!
    @IBOutlet var cellCurrentEntry2: UITableViewCell!
    
    
    @IBOutlet var pickerGas: UIPickerView!
    @IBOutlet var pickerCity: UIPickerView!
    
    @IBOutlet var btnTVEnter: UIButton!
    

        
    // MARK: - Viewcontroller life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disables highlighted when tappeed
        let allCells: [UITableViewCell] = [cellDate, cellGas1, cellGas2, cellOdometer, cellDestination, cellCurrentEntry1, cellCurrentEntry2]
        
        for cell in allCells {
            cell.selectionStyle = .none
        }
        
        // Load destinations
        destination.loadDestinations()
        
        self.hideKeyboardWhenTappedAround()
        
        // Rounds button
        btnTVEnter.layer.cornerRadius = 10
        
        // sets the initial date
        lblDate.text = "Date: \(NSDate().formatted)"
        lblDateStepper.text = "\(NSDate().formatted)"
        
        self.view.bringSubviewToFront(pickerGas)
        self.view.bringSubviewToFront(pickerCity)
        
        loadData()
        
        // Get first odometer reading for initial launch
        if (data.count < 1) {
            self.getFirstReading()
            self.txtOdometer.text = strOdometer
        }
        else {
            tempEntry.sMileage = data[0].eMileage
            strOdometer = tempEntry.sMileage
            lblStartMiles.text = "Start \(strOdometer)"
            txtOdometer.text = strOdometer
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        txtOdometer.font = UIFont(name: "DBLCDTempBlack", size: 22)
        txtTotalSale.font = UIFont(name: "DBLCDTempBlack", size: 18)
        
        // Prices for gas Pickerview
        for i in 251...450 {
            prices.append(i)
        }
        
        self.pickerGas.selectRow(100, inComponent: 0, animated: true)
        
        // Check for modified Destination City array
        let storedArrCities = userDefaults.object(forKey: "arrDestinations") as? [String]
        if storedArrCities == nil {
            
            
            // Store default cities
            userDefaults.set(destination.city, forKey: "arrDestinations")
        }
        else if storedArrCities?.count != destination.city.count {
            destination.city = storedArrCities!
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        gasIndex = returnGasIndex()
        self.pickerGas.selectRow(gasIndex, inComponent: 0, animated: true)
    }
    
    
    // Checks if there's at least one recorded gas price this month
    func isFirstTank() -> Bool {
        var count = data.count - 1
        while (count >= 0) {
            if data[count]._tSale != "" {
                return true
            }
            else {
                count = count - 1
            }
        }
        return false
    }
    
    
    @objc func loadList(){
        
        // load data here
        self.loadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 1
        
        if (section == 1 || section == 4) {
            rows = 2
        }
        return rows
    }
    
    func updateDate() {
        tempDate = selectedDate as NSDate
        let tempStr = tempDate.formatted
        lblDateStepper.text = "\(tempStr)"
        lblDate.text = "Date: \(tempStr)"
        tempEntry._strDate  = tempStr
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "DBLCDTempBlack", size: 18)
            pickerLabel?.textAlignment = .center
        }
        
    
        if (pickerView == pickerCity) {

            var tempStr = ""
            if destination.city[row] == "Crazy" { tempStr = tempStr + "             5150 miles"}
            else if destination.city[row] == "Las Vegas" { tempStr = tempStr + "        202 miles"}
            else if destination.city[row] == "North Hills" { tempStr = tempStr + "         95 miles"}
            else if destination.city[row] == "Redlands" { tempStr = tempStr + "           56 miles"}
            else if destination.city[row] == "San Bernardino" { tempStr = tempStr + "    44 miles"}
            else if destination.city[row] == "San Diego" { tempStr = tempStr + "        152 miles"}
            else if destination.city[row] == "29 Palms" { tempStr = tempStr + "            85 miles"}
            
            pickerLabel?.text = destination.city[row] + tempStr
            pickerLabel?.font = UIFont(name: "Clearview", size: 18)
            pickerLabel?.textColor = UIColor.white
            
        }
        else {
            let amount: Double = (Double (prices[row]))/(100.0)
            let amountString = String(format: "%.02f9", amount)
            
            pickerLabel?.text = amountString
            pickerLabel?.textColor = UIColor.black
            
            strPrice = amountString
        }
        
        return pickerLabel!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // Picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == pickerCity) {
            return destination.city.count
        }
        else if (pickerView == pickerGas) {
            return prices.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // update label
        if (pickerView == pickerCity) {
            tempEntry.destination = destination.city[row]
            
            if row == 0 {
                lblDestination.text = "Destination"
                tempEntry._destination = ""
            }
            else {
                lblDestination.text = tempEntry.destination
            }
        }
        else if (pickerView == pickerGas){
            gasPrice = String(format: "%.02f", Double(prices[row])/100.0)
            tempEntry.pricePerGallon =  gasPrice
            
            lblCostPerGal.text = "$ \(gasPrice) \\ Gal"
        }
    }
    
    
    func getFirstReading() {
        
        // First Entry
        let alert = UIAlertController(title: "Welcome to the Mileage Tracker App!",
                                      message: "Please enter your current odometer mileage:",
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        let save = UIAlertAction(title: "Save", style: .default) {
            (alertAction: UIAlertAction) in
            
            odometer = alert.textFields![0].text!
            let firstEntry = MileageEntry().createNewMonthFirstEntry(odometer: odometer)
            
            self.saveData(mileageEntry: firstEntry)
            self.tableView.reloadData()
        }
        
        alert.addAction(save);
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [MileageEntry] {
            data = ourData;
        }
    }
    
    func saveData(mileageEntry: MileageEntry ) {

        data.insert(mileageEntry, at: 0)
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)  // Saves array of data
    }
    
    func submitEntry() {
        if (data.count == 0){
            tempEntry._sMileage = txtOdometer.text!
            tempEntry._eMileage = txtOdometer.text!
            tempEntry._destination = "First Entry"
            tempEntry._tMileage = "0"
        }
        else {
            tempEntry._sMileage = data[0]._eMileage
            tempEntry._eMileage = txtOdometer.text!
            tempEntry._tMileage = getDifference(a: tempEntry._eMileage, b: tempEntry._sMileage)
        }
        
        if (tempEntry.destination == "Destination") {
            tempEntry.destination = ""
        }
        if (txtTotalSale?.text != "00.00") {
            let dblTSale = Double(txtTotalSale.text!)!
            let strTSale = String(format: "%.02f", Double(dblTSale))
            tempEntry._tSale = strTSale
        }
        
        let newEntry = MileageEntry(date: selectedDate as Date, strDate: tempEntry._strDate, sMileage: tempEntry._sMileage, eMileage: tempEntry.eMileage, tMileage: tempEntry._tMileage, tSale: tempEntry._tSale, pricePerGallon: tempEntry.pricePerGallon, destination: tempEntry._destination)
        
        if (tempEntry.pricePerGallon != "" ) {
            recordLastGasPrice(price: tempEntry.pricePerGallon)
        }
        
        self.saveData(mileageEntry: newEntry)
        view.endEditing(true)
    }
    
    func getDifference(a: String, b: String) -> String {
        var c = ""
        var intA, intB, intC: Int
        if (a != "" && b != "")
        {
            intA = Int(a)!
            intB = Int(b)!
            intC = intA - intB
            c = String(intC)
        }
        return c
    }
    
    func returnGasIndex() -> Int {
        
        guard let gasP = userDefaults.object(forKey: "lastGasPrice") as? String else { return 0}
        
        var tempIndex = Double(gasP)
        tempIndex = tempIndex!*100
        gasIndex = (Int(tempIndex!)-250)
        
        return gasIndex
    }
    
    
    // MARK: - Action methods
    
    @IBAction func dateStepper(_ sender: UIStepper) {
        selectedDate = (NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.date(byAdding: .day, value: Int(sender.value), to: NSDate() as Date, options: [])! as NSDate as NSDate) as Date
        
        updateDate()
    }
    
    // Update total miles, difference between startMiles and endMiles
    func updateTotalMiles() {
        
        let intS = Int(tempEntry.sMileage)
        let intE = Int(tempEntry.eMileage)
        if tempEntry.sMileage != "" && intE != nil {
            tempEntry._tMileage = String(intE! - intS!)
            lblTotalMiles.text = "Total \(tempEntry._tMileage)"
        }
    }
    
    @IBAction func updateTotalSale(_ sender: Any) {
        
        let dblTSale = Double(txtTotalSale.text!)!
        let strTSale = String(format: "%.02f", Double(dblTSale))
        tempEntry._tSale = txtTotalSale.text!
        lblTotalSale.text = "Total $\(strTSale)"
        txtTotalSale.text = "\(strTSale)"
    }
    
    @IBAction func updateEndMiles(_ sender: Any) {
        updateTotalMiles()
        if (txtOdometer.text?.count)! < strOdometer.count {
            txtOdometer.text = strOdometer
        }
    }
    
    @IBAction func editChangedOdometer(_ sender: Any) {
        var sMiles = 0
        var eMiles = 0
        
        if (tempEntry._sMileage != "") {
            sMiles = Int(tempEntry._sMileage)!
        }
        
        if txtOdometer.text != "" {
            eMiles = Int(txtOdometer.text!)!
        }
        
        tempEntry.eMileage = txtOdometer.text!
        lblEndMiles.text = "End \(tempEntry.eMileage)"
        
        if (eMiles - sMiles) > 0 {
            lblTotalMiles.text = "Total \(eMiles - sMiles)"
        }
    }
    
    
    @IBAction func beginEditOdometer(_ sender: Any) {
        if txtOdometer.text != nil && txtOdometer.text!.count > 3{
            let lenStr = txtOdometer.text?.count
            txtOdometer.text = String(txtOdometer.text!.prefix(lenStr!-3))
        }
    }
    
    @IBAction func btnTVEnter(_ sender: Any) {
        self.submitEntry()
    }
    
    func recordLastGasPrice(price: String) {
        tempSettings._strLastGasPrice = price
        
        var lastGasReading = ""
        var recordLastGasReading = true
        
        lastGasReading = tempEntry._eMileage
        
        // Store Value
        userDefaults.set("\(price)", forKey: "lastGasPrice")
        
        // Also store odometer reading for future use if it's not the first tank
        recordLastGasReading = isFirstTank()
        if (recordLastGasReading) {
            userDefaults.set("\(lastGasReading)", forKey: "strLastGasOdometer")
            let lastGasOdometer = String(userDefaults.string(forKey: "strLastGasOdometer")!)
        }
    }
    
    // MARK: - Navigate
    
    @IBAction func unwindToSingleEntry(for unwindSegue: UIStoryboardSegue) {
        
    }
}
