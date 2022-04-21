//
//  RGBComponents.swift
//  CustomColorPicker
//
//  Created by Slik on 19.04.2022.
//

import UIKit
import SwiftUI

public struct RGBAComponents {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    var uiColor: UIColor {
        get {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    var color: Color {
        get {
            return Color(red: red, green: green, blue: blue, opacity: alpha)
        }
    }
}
