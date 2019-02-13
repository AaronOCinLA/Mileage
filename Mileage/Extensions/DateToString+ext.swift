//
//  Date+ext.swift
//  Mileage
//
//  Created by Aaron O'Connor on 1/30/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import Foundation


extension Date {
    var dateToString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func getMonthInt() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "L"
        let monthInt = Int(formatter.string(from: self))
        return monthInt!
    }
    
    func getMonthShortString(x: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        let previousMonth = Calendar.current.date(byAdding: .month, value: x, to: self)
        return formatter.string(from: previousMonth!)
    }
    
    func getDifferenceOfMonths() -> Int {
        let calendar = Calendar.current
        let components = DateComponents(day:1)
        let dateA = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)!
        return Calendar.current.dateComponents([.month], from: self, to: dateA).month ?? 0
    }
}
