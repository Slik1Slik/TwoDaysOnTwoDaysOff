//
//  ColorPalette Builder.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI

class ColorPaletteBuillder {
    static var user: ColorPalette {
        let colorPalette = ColorPalette()
        colorPalette.buttonPrimary = Color(UserSettings.restDayCellColor!)
        return colorPalette
    }
    
    static var monochrome: ColorPalette {
        return ColorPalette()
    }
}
