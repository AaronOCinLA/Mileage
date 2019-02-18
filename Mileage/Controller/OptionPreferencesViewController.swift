//
//  OptionPreferencesViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/18/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit

class OptionPreferencesViewController: UIViewController {
    
    var tire = false
    var oil = false
    
    
    var userDefault = UserDefaults.standard
    
    @IBOutlet var tiresSwitch: UISwitch!
    @IBOutlet var oilSwitch: UISwitch!
    
    @IBOutlet var reportHistoryLenghtSlider: UISlider!
    @IBOutlet var  reportHistoryLenghtLabel: UILabel!
    
    var reporHistoryLengthInt = 6
    
    
    @IBAction func didUpdateReportHistoryLengthSlider(_ sender: UISlider) {
        reporHistoryLengthInt = Int(sender.value)
        reportHistoryLenghtLabel.text = "Report History Length: \(reporHistoryLengthInt) months"
    }
    
    @IBAction func didUpdateTiresSwitch(_ sender: UISwitch) {
        tire = !tire
        userDefault.set(tire, forKey: "trackTireMileage")
    }
    
    @IBAction func didUPdateOilChangeSwitch(_ sender: UISwitch) {
        oil = !oil
        userDefault.set(oil, forKey: "trackOilMileage")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportHistoryLenghtSlider.value = 6
        
        // Get user preferences
        if let trackTireMileage = userDefault.value(forKey: "trackTireMileage") {
            tire = trackTireMileage as! Bool
        }
        
        // Get user preferences
        if let trackOilMileage = userDefault.value(forKey: "trackOilMileage") {
            oil = trackOilMileage as! Bool
        }
        
        tiresSwitch.isOn = tire
        oilSwitch.isOn = oil
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
