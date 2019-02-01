//
//  ViewControllerCharts.swift
//  Mileage
//
//  Created by Aaron O'Connor on 12/21/17.
//  Copyright © 2017 Aaron O'Connor. All rights reserved.
//

import UIKit

var totalCost = 0.0
var totalMiles = 0

struct bestTank {
    var curSale = 0.00
    var cpGal = 0.00
    var endMiles = 0
    
    init() {
        curSale = 0.00
        cpGal = 0.00
        endMiles = 0
    }
}

class ViewControllerCharts: UIViewController {
    
    @IBOutlet weak var lblLastTrip: UILabel!
    
    @IBOutlet weak var lblTlSpent: UILabel!
    @IBOutlet weak var lblTlMiles: UILabel!
    
    @IBOutlet weak var lblDest: UILabel!
    
    @IBOutlet weak var viewTrip: UIView!
    @IBOutlet weak var viewSpent: UIView!
    @IBOutlet weak var viewMiles: UIView!
    
    
    // http://www.kaleidosblog.com/swift-data-structure-how-to-create-sort-filter-array-of-objects-in-swift
    // var filtered_list = list.filter({$0.number < 10})
    
    var filteredData = [MileageEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        filteredData = data.filter({$0._tSale != "" })
        
        var strDest = ""
        if data.count > 0 && data[0]._destination != "" {
            strDest = "way o'er yonder to \(data[0]._destination)"
            lblDest.text = "\(strDest)"
            lblDest.isHidden = false
        }
        else {
            lblDest.isHidden = true
        }
        
        let intLastTrip = getLastTrip()
        if (intLastTrip == 0) {
            lblLastTrip.text = "No memories to report. \nTime to make new ones."
        }
        else {
            lblLastTrip.text = "Your last trip was \n\(intLastTrip)  Miles"
        }
        
        viewSpent.isHidden = true
        viewMiles.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let tempEntry = MileageEntry()
        let spent = tempEntry.getTotalSpent()
        //let strLables = ["Total Spent this month: $", "Total Miles this month: "]
        var tlMiles = 0
        
        if data.count > 1 {
            tlMiles = data[0].getTotalMiles()
        }
        
        UIView.animate(withDuration: 0.6, animations: { self.viewTrip.frame.origin.y = 58}, completion: nil)
        
        if spent > 0 {
            let amountString = String(format: "%.02f", spent)
            lblTlSpent.text = "$\(amountString)"
            viewSpent.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0.2, animations: { self.viewSpent.frame.origin.x = 0}, completion: nil)
        }
        if tlMiles != 0 {
            lblTlMiles.text = "\(tlMiles)"
            viewMiles.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0.4, animations: { self.viewMiles.frame.origin.x = 0}, completion: nil)
        }
    }
    
    func getLastTrip() -> Int {
        var intLastTrip = 0
        
        if data.count > 0 {
            if(data[0]._tMileage != "") {
                intLastTrip = Int(data[0]._tMileage)!
            }
        }
        return intLastTrip
    }
}
