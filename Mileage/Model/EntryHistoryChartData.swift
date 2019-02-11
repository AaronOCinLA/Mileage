//
//  EntryHistoryChartData.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/6/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import Foundation

class EntryHistoryChartData {
    
    var odometerEntries: [Int]
    var totalGas: Double?
    var destinationArray: [String]?
    
    init(odometerEntries: [Int], totalGas: Double, destinationArray: [String]) {
        self.odometerEntries = odometerEntries
        self.totalGas = totalGas
        self.destinationArray = [String]()
    }
    
    convenience init() {
        self.init(odometerEntries: [], totalGas: 0.0, destinationArray: [])
    }
    
    func getTotalMilesForMonth() -> Int {
        var totalMiles = 0
        if let endMiles = self.odometerEntries.max()  {
            totalMiles = endMiles - self.odometerEntries.min()!
        }
        return totalMiles
    }

    func getDestinationVisitCount() -> [String:Int] {
        
        if let destinationArray = self.destinationArray {
            let counts = destinationArray.reduce(into: [:]) {
                counts, word in counts[word, default: 0] += 1
            }
            return counts
        }
        else {
            return ["":0]
        }
    }
}
