//
//  Date+ext.swift
//  Mileage
//
//  Created by Aaron O'Connor on 1/30/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import Foundation

extension Date {
    var monthMedium: String  { return Formatter.monthMedium.string(from: self) }
    var hour12:  String      { return Formatter.hour12.string(from: self) }
    var minute0x: String     { return Formatter.minute0x.string(from: self) }
    var amPM: String         { return Formatter.amPM.string(from: self) }
}

extension NSDate {
    var formatted: String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yy"
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return df.string(from: self as Date)
    }
}

extension Formatter {
    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter
    }()
    static let hour12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        return formatter
    }()
    static let minute0x: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    static let amPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }()
}
