//
//  Colors.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.03.2022.
//

import Foundation
import SwiftUI

class ApplicationColorPalette {
    
    static var shared: ColorPalette {
        var colorTheme = ColorTheme()
        let colorPalette = ColorPalette()
        do {
            guard let userThemeID = UserSettings.colorThemeID else {
                return colorPalette
            }
            colorTheme = try UserColorThemeManager.shared.find(forID: userThemeID)
        } catch {
            return colorPalette
        }
        colorPalette.buttonPrimary = colorTheme.accent.color
        return colorPalette
    }
    
    static var calendar: CalendarColorPalette {
        var colorTheme = ColorTheme()
        let colorPalette = CalendarColorPalette()
        do {
            guard let userThemeID = UserSettings.colorThemeID else {
                return colorPalette
            }
            colorTheme = try UserColorThemeManager.shared.find(forID: userThemeID)
        } catch {
            return colorPalette
        }
        colorPalette.restDayText = colorTheme.restDayText.color
        colorPalette.workingDayText = colorTheme.workingDayText.color
        
        colorPalette.restDayBackground = colorTheme.restDayBackground.color
        colorPalette.workingDayBackground = colorTheme.workingDayBackground.color
        
        return colorPalette
    }
    
    static var monochromeColorPalette: ColorPalette {
        return ColorPalette()
    }
    
    static var monochromeCalendarColorPalette: CalendarColorPalette {
        return CalendarColorPalette()
    }
}

class ColorPalette {
    
    var inactive: Color
    var highlighted: Color
    var destructive: Color
    
    var buttonPrimary: Color
    var buttonSecondary: Color
    var buttonTertiary: Color
    
    var textPrimary: Color
    var textSecondary: Color
    var textTertiary: Color
    
    var backgroundPrimary: Color
    var backgroundSecondary: Color
    var backgroundTertiary: Color
    
    private let baseColor = BaseColor()
    
    init() {
        inactive = baseColor.inactive
        highlighted = baseColor.highlighted
        destructive = baseColor.destructive
        
        buttonPrimary = baseColor.accentPrimary
        buttonSecondary = baseColor.accentSecondary
        buttonTertiary = baseColor.accentTertiary
        
        textPrimary = baseColor.contentPrimary
        textSecondary = baseColor.contentSecondary
        textTertiary = baseColor.contentTertiary
        
        backgroundPrimary = baseColor.themePrimary
        backgroundSecondary = baseColor.themeSecondary
        backgroundTertiary = baseColor.themeTertiary
    }
}

class CalendarColorPalette {
    
    var workingDayText: Color
    var restDayText: Color
    
    var workingDayBackground: Color
    var restDayBackground: Color
    
    private let monochromeColorTheme = DefaultColorTheme.monochrome.theme
    
    init() {
        workingDayText = monochromeColorTheme.workingDayText.color
        restDayText = monochromeColorTheme.restDayText.color
        
        workingDayBackground = monochromeColorTheme.workingDayBackground.color
        restDayBackground = monochromeColorTheme.restDayBackground.color
    }
}

struct BaseColor {
    let inactive: Color = Color("inactive")
    let highlighted: Color = Color("highlighted")
    let destructive: Color = Color("destructive")
    
    let accentPrimary: Color = Color("accentPrimary")
    let accentSecondary: Color = Color("accentSecondary")
    let accentTertiary: Color = Color("accentTertiary")
    
    let contentPrimary: Color = Color("contentPrimary")
    let contentSecondary: Color = Color("contentSecondary")
    let contentTertiary: Color = Color("contentTertiary")
    
    let themePrimary: Color = Color("themePrimary")
    let themeSecondary: Color = Color("themeSecondary")
    let themeTertiary: Color = Color("themeTertiary")
}
