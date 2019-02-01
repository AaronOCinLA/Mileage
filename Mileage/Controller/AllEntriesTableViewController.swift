//
//  AllEntriesTableViewController.swift
//  Mileage
//
//  Created by Aaron O'Connor on 12/18/17.
//  Copyright © 2017 Aaron O'Connor. All rights reserved.
//


// To do: dedupe

import UIKit

class AllEntriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
        
    @IBOutlet weak var lblText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UITableView Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Fade image for gaspump
        let image = UIImage(named: "gasPump")
        let transparentImage = image?.image(alpha: 0.2)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CustomTableViewCell
        
        cell.lblDate?.text = data[indexPath.row]._strDate
        cell.lblDestination?.text = "\(data[indexPath.row].destination)"
        
        cell.lblSMileage?.text = "Start  \(data[indexPath.row]._sMileage)"
        cell.lblEMileage?.text = "End  \(data[indexPath.row]._eMileage)"
        cell.lblTMileage?.text = "Total  \(data[indexPath.row]._tMileage)"
        
        cell.lbltSale?.text = "Total $ \(data[indexPath.row]._tSale)"
        cell.lblMpg?.text = "$\(data[indexPath.row]._pricePerGallon) / Gallon"
        
        cell.imageGas?.image = transparentImage
        if data[indexPath.row]._tSale == "" {
            cell.imageGas.isHidden = true
        }
        else {
            cell.imageGas.isHidden = false
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Action methods
    
    func removeDupes() {
        var keepGoing = true
        
        if data.count > 1 {
            if data[0]._destination != data[1]._destination {
                keepGoing = false
            }
            if data[0]._sMileage != data[1]._sMileage {
                keepGoing = false
            }
            if data[0]._eMileage != data[1]._eMileage {
                keepGoing = false
            }
            if data[0]._tSale != data[1]._tSale {
                keepGoing = false
            }
            if data[0]._pricePerGallon != data[1]._pricePerGallon {
                keepGoing = false
            }
        }
        if (keepGoing == true) {
            data.remove(at: 0)
            NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
        }
    }
}


