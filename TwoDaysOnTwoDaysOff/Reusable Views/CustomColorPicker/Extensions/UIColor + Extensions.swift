//
//  UIColor + Extensions.swift
//  CustomColorPicker
//
//  Created by Slik on 19.04.2022.
//

import UIKit

extension UIColor {
    
    var rgbaComponents: RGBAComponents {
        get {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return RGBAComponents(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    var hsbaComponents: HSBAComponents {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return HSBAComponents(hue: h, saturation: s, brightness: b, alpha: a)
    }
}


