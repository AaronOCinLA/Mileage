//
//  Image_Alpha-ext.swift
//  Mileage
//
//  Created by Aaron O'Connor on 1/30/19.
//  Copyright © 2019 Aaron O'Connor. All rights reserved.
//

import UIKit

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
