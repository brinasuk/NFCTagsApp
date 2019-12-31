//
//  UIColor+Ext.swift
//  FoodPin
//
//  Created by Simon Ng on 18/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
    
    fileprivate enum MaterialUI {
    static let orange600 = UIColor(red:   0xFB / 0xFF,
                                   green: 0x8C / 0xFF,
                                   blue:  0x00 / 0xFF,
                                   alpha: 1) // #FB8C00
    }

}

