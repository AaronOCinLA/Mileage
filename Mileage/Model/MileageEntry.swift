//
//  MileageEntry.swift
//  Mileage
//
//  Created by Aaron O'Connor on 12/14/17.
//  Copyright © 2017 Aaron O'Connor. All rights reserved.
//

import Foundation

class MileageEntry: NSObject, NSCoding {
   
    struct Keys {
        static let date = "date"
        static let strDate = "strDate"
        static let sMileage = "sMileage"
        static let eMileage = "eMileage"
        static let tMileage = "tMileage"
        static let tSale = "tSale"
        static let pricePerGallon = "pricePerGallon"
        static let destination = "destination"
    }
    
    var _date = Date()
    var _strDate = ""
    var _sMileage = ""
    var _eMileage = ""
    var _tMileage = ""
    var _tSale = ""
    var _pricePerGallon = ""
    var _destination =  ""
    
    override init() {}
    
    init(date: Date, strDate: String, sMileage: String, eMileage: String, tMileage: String, tSale: String,
         pricePerGallon: String, destination: String) {
        self._date = date
        self._strDate = strDate
        self._sMileage = sMileage
        self._eMileage = eMileage
        self._tMileage = tMileage
        self._tSale = tSale
        self._pricePerGallon = pricePerGallon
        self._destination = destination
    }
    
    required init(coder aDecoder: NSCoder) {
        if let dateObj = aDecoder.decodeObject(forKey: Keys.date) as? Date {
            _date = dateObj
        }
        if let strDateObj = aDecoder.decodeObject(forKey: Keys.strDate) as? String {
            _strDate = strDateObj
        }
        if let sMileageObj = aDecoder.decodeObject(forKey: Keys.sMileage) as? String {
            _sMileage = sMileageObj
        }
        if let eMileageObj = aDecoder.decodeObject(forKey: Keys.eMileage) as? String {
            _eMileage = eMileageObj
        }
        if let tMileageObj = aDecoder.decodeObject(forKey: Keys.tMileage) as? String {
            _tMileage = tMileageObj
        }
        if let tSaleObj = aDecoder.decodeObject(forKey: Keys.tSale) as? String {
            _tSale = tSaleObj
        }
        if let pricePerGallonObj = aDecoder.decodeObject(forKey: Keys.pricePerGallon) as? String {
            _pricePerGallon = pricePerGallonObj
        }
        if let destinationObj = aDecoder.decodeObject(forKey: Keys.destination) as? String {
            _destination = destinationObj
        }
    }
    
    func encode(with aCoder: NSCoder){
        
        aCoder.encode(_date, forKey: Keys.date)
        aCoder.encode(_strDate, forKey: Keys.strDate)
        aCoder.encode(_sMileage, forKey: Keys.sMileage)
        aCoder.encode(_eMileage, forKey: Keys.eMileage)
        aCoder.encode(_tMileage, forKey: Keys.tMileage)
        aCoder.encode(_tSale, forKey: Keys.tSale)
        aCoder.encode(_pricePerGallon, forKey: Keys.pricePerGallon)
        aCoder.encode(_destination, forKey: Keys.destination)
    }
    
    func createNewMonthFirstEntry(odometer: String) -> MileageEntry {
        let today = NSDate()
        let strDate = today.formatted
        
        let firstEntry = MileageEntry(date: today as Date,
                                      strDate: strDate,
                                      sMileage: odometer,
                                      eMileage: odometer,
                                      tMileage: "",
                                      tSale: "",
                                      pricePerGallon: "",
                                      destination: "")
        
        return firstEntry
    }
    
    func getTotalSpent() -> Double {
        
        var dblTlSpent = 0.00
        
        // Get date for each row
        if data.count > 1 {
            for i in 0 ... (data.count-1) {
                if (data[i]._tSale != "") {
                    dblTlSpent = dblTlSpent + Double(data[i]._tSale)!  // Increment total cost spent on gas
                }
            }
        }
        
        return dblTlSpent
    }
    
    func getTotalMiles() -> Int {
        
        var tlMiles = 0
        
        if data.count > 1 {
            tlMiles = Int(data[0].eMileage)! - Int(data[data.count - 1].eMileage)!
        }
        
        return tlMiles
    }
    
    var date: Date {
        get {
            return _date;
        }
        set {
            _date = newValue;
        }
    }
    var strDate: String {
        get {
            return _strDate;
        }
        set {
            _strDate = newValue;
        }
    }
    var sMileage: String {
        get {
            return _sMileage;
        }
        set {
            _sMileage = newValue;
        }
    }
    var eMileage: String {
        get {
            return _eMileage;
        }
        set {
            _eMileage = newValue;
        }
    }
    var tMileage: String {
        get {
            return _tMileage;
        }
        set {
            _tMileage = newValue;
        }
    }
    var tSale: String {
        get {
            return _tSale;
        }
        set {
            _tSale = newValue;
        }
    }
    var pricePerGallon: String {
        get {
            return _pricePerGallon;
        }
        set {
            _pricePerGallon = newValue;
        }
    }
    var destination: String {
        get {
            return _destination;
        }
        set {
            _destination = newValue;
        }
    }
}
