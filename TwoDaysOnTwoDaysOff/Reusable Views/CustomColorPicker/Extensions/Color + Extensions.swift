//
//  Color + Extensions.swift
//  CustomColorPicker
//
//  Created by Slik on 19.04.2022.
//

import SwiftUI

extension Color {
    
    var uiColor: UIColor {
        return UIColor(self)
    }
    
    var isDark: Bool {
        let rgb = self.uiColor.rgbaComponents
        let lum = rgb.red * 0.2126 + rgb.green * 0.7152 + rgb.blue * 0.0722
        return lum < 0.50
    }
    
    var isTransparent: Bool {
        return self.uiColor.hsbaComponents.alpha < 0.50
    }
    
    func isEqual(to color: Color, by component: ColorComponent) -> Bool {
        switch component {
        case .red:
            return self.uiColor.rgbaComponents.red == color.uiColor.rgbaComponents.red
        case .green:
            return self.uiColor.rgbaComponents.green == color.uiColor.rgbaComponents.green
        case .blue:
            return self.uiColor.rgbaComponents.blue == color.uiColor.rgbaComponents.blue
        case .hue:
            return self.uiColor.hsbaComponents.hue == color.uiColor.hsbaComponents.hue
        case .saturation:
            return self.uiColor.hsbaComponents.saturation == color.uiColor.hsbaComponents.saturation
        case .brightness:
            return self.uiColor.hsbaComponents.brightness == color.uiColor.hsbaComponents.brightness
        case .alpha:
            return self.uiColor.hsbaComponents.alpha == color.uiColor.hsbaComponents.alpha
        }
    }
    
    enum ColorComponent {
        case red
        case green
        case blue
        
        case hue
        case saturation
        case brightness
        case alpha
    }
}
