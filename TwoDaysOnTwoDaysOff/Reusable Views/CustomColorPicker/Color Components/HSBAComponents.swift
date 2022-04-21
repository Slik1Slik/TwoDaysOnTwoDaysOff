//
//  HSBAComponents.swift
//  CustomColorPicker
//
//  Created by Slik on 19.04.2022.
//

import UIKit
import SwiftUI

public struct HSBAComponents: Codable, Hashable {
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat
    var alpha: CGFloat
    
    var uiColor: UIColor {
        get {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
    }
    
    var color: Color {
        get {
            return Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
        }
    }
}
