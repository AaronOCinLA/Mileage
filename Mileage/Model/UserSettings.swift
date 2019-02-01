//
//  UserSettings.swift
//  Mileage
//
//  Created by Aaron O'Connor on 12/24/17.
//  Copyright © 2017 Aaron O'Connor. All rights reserved.
//

import Foundation

class UserSettings: NSObject, NSCoding {
    
    struct Keys {
        static let strLastGasPrice = "strLastGasPrice"
        static let arrDestinations = "arrDestinations"
        static let strTotalMiles = "tMileage"
        static let strTotalSpent = "tSale"
        static let strLastGasOdometer = "strLastGasOdometer"
    }
    
    var _strLastGasPrice = ""
    var _arrDestinations = [""]
    var _strTotalMiles = ""
    var _strTotalSpent = ""
    var _strLastGasOdometer = ""
    
    override init() {}
    
    init(strLastGasPrice: String, arrDestinations: [String], strTotalMiles: String, strTotalSpent: String, strLastGasOdometer: String) {
        self._strLastGasPrice = strLastGasPrice
        self._arrDestinations = arrDestinations
        self._strTotalMiles = strTotalMiles
        self._strTotalSpent = strTotalSpent
        self._strLastGasOdometer = strLastGasOdometer
    }
    
    required init(coder aDecoder: NSCoder) {
        if let strLastGasPriceObj = aDecoder.decodeObject(forKey: Keys.strLastGasPrice) as? String {
            _strLastGasPrice = strLastGasPriceObj
        }
        if let arrDestinationsObj = aDecoder.decodeObject(forKey: Keys.arrDestinations) as? [String] {
            _arrDestinations = arrDestinationsObj
        }
        if let strTotalMilesObj = aDecoder.decodeObject(forKey: Keys.strTotalMiles) as? String {
            _strTotalMiles = strTotalMilesObj
        }
        if let strTotalMilesObj = aDecoder.decodeObject(forKey: Keys.strTotalMiles) as? String {
            _strTotalMiles = strTotalMilesObj
        }
        if let strTotalSpentObj = aDecoder.decodeObject(forKey: Keys.strTotalSpent) as? String {
            _strTotalSpent = strTotalSpentObj
        }
        if let strLastGasOdometerObj = aDecoder.decodeObject(forKey: Keys.strLastGasOdometer) as? String {
            _strLastGasOdometer = strLastGasOdometerObj
        }
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(_strLastGasPrice, forKey: Keys.strLastGasPrice)
        aCoder.encode(_arrDestinations, forKey: Keys.arrDestinations)
        aCoder.encode(_strTotalMiles, forKey: Keys.strTotalMiles)
        aCoder.encode(_strTotalSpent, forKey: Keys.strTotalSpent)
        aCoder.encode(_strLastGasOdometer, forKey: Keys.strLastGasOdometer)
    }
    
    
    var strLastGasPrice: String {
        get {
            return _strLastGasPrice;
        }
        set {
            _strLastGasPrice = newValue;
        }
    }
    var arrDestinations: [String] {
        get {
            return _arrDestinations;
        }
        set {
            _arrDestinations = newValue;
        }
    }
    var sMileage: String {
        get {
            return _strTotalMiles;
        }
        set {
            _strTotalMiles = newValue;
        }
    }
    var eMileage: String {
        get {
            return _strTotalSpent;
        }
        set {
            _strTotalSpent = newValue;
        }
    }
    var strLastGasOdometer: String {
        get {
            return _strLastGasOdometer;
        }
        set {
            _strLastGasOdometer = newValue;
        }
    }
}
