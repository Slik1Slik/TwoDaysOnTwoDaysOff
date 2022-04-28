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
    
    func setValue(_ value: CGFloat, to component: HSBAComponent) -> UIColor {
        let hsba = self.hsbaComponents
        switch component {
        case .hue:
            return UIColor(hue: value, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
        case .saturation:
            return UIColor(hue: hsba.saturation, saturation: value, brightness: hsba.brightness, alpha: hsba.alpha)
        case .brightness:
            return UIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: value, alpha: hsba.alpha)
        case .alpha:
            return UIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: value)
        }
    }
    
    func setValue(_ value: CGFloat, to component: RGBAComponent) -> UIColor {
        let rgba = self.rgbaComponents
        switch component {
        case .red:
            return UIColor(red: value, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
        case .green:
            return UIColor(red: rgba.green, green: value, blue: rgba.blue, alpha: rgba.alpha)
        case .blue:
            return UIColor(red: rgba.red, green: rgba.green, blue: value, alpha: rgba.alpha)
        case .alpha:
            return UIColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: value)
        }
    }
    
    enum HSBAComponent {
        case hue
        case saturation
        case brightness
        case alpha
    }

    enum RGBAComponent {
        case red
        case green
        case blue
        case alpha
    }
}


