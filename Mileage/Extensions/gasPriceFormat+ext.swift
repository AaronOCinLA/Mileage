//
//  gasPriceFormat+ext.swift
//  Mileage
//
//  Created by Aaron O'Connor on 2/5/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import Foundation

extension Double {
    func gasPriceFormat() -> String {
        return (String(format: "%.2f9", self))
    }
}
