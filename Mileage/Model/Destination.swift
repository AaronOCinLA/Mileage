//
//  Destination.swift
//  Mileage
//
//  Created by Aaron O'Connor on 1/30/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit

class Destination {
    
    var city: [String]
    
    init () {
        self.city = [String]()
    }
    
    func loadDestinations() {
        
        // TODO: Revove this:
        let arrCities = ["Destination Unknown", "Las Vegas", "North Hills", "Redlands", "San Bernardino", "San Diego", "29 Palms", "Crazy"]
        self.city = arrCities
    }
}
