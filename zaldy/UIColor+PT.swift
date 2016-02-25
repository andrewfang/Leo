//
//  UIColor+PT.swift
//  zaldy
//
//  Created by Andrew Fang on 2/23/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(red:CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    static func rgba(red:CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    static func appColor() -> UIColor {
        return rgb(52, 73, 94)
    }
    
    static func appColorAlphaHalf() -> UIColor {
        return rgba(52, 73, 94, 0.5)
    }
}