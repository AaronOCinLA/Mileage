//
//  MileageEntry.swift
//  Mileage
//
//  Created by Aaron O'Connor on 12/14/17.
//  Copyright © 2017 Aaron O'Connor. All rights reserved.
//

import Foundation

class MileageEntry {
    
    var date: Date
    var odometer: Int
    var totalSale: Double
    var pricePerGallon: Double
    var destination: String
    
    init(date: Date, odometer: Int, totalSale: Double, pricePerGallon: Double, destination: String) {
        
        self.date = date
        self.odometer = odometer
        self.totalSale = totalSale
        self.pricePerGallon = pricePerGallon
        self.destination = destination
    }
    
    convenience init() {
        self.init(date: Date(), odometer: 0, totalSale: 0.0, pricePerGallon: 0.0, destination: "")
    }
}
