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
            colorTheme = try UserColorThemeManager.shared.find(forID: UserSettings.colorThemeID!)
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
            colorTheme = try UserColorThemeManager.shared.find(forID: UserSettings.colorThemeID!)
        } catch {
            return colorPalette
        }
        colorPalette.restDayText = colorTheme.restDayText.color
        colorPalette.workingDayText = colorTheme.workingDayText.color
        
        colorPalette.restDayBackground = colorTheme.restDayBackground.color
        colorPalette.workingDayBackground = colorTheme.workingDayBackground.color
        
        return colorPalette
    }
}

class ColorPalette {
    
    var inactive: Color
    var highlighted: Color
    
    var buttonPrimary: Color
    var buttonSecondary: Color
    
    var textPrimary: Color
    var textSecondary: Color
    
    var backgroundDefault: Color
    var backgroundForm: Color
    
    private let baseColor = BaseColor()
    private let calendarColor = CalendarColor()
    
    init() {
        inactive = baseColor.inactive
        highlighted = baseColor.highlighted
        
        buttonPrimary = baseColor.accentPrimary
        buttonSecondary = baseColor.accentSecondary
        
        textPrimary = baseColor.contentPrimary
        textSecondary = baseColor.contentSecondary
        
        backgroundDefault = baseColor.themePrimary
        backgroundForm = baseColor.themeSecondary
    }
}

class CalendarColorPalette {
    
    var workingDayText: Color
    var restDayText: Color
    
    var workingDayBackground: Color
    var restDayBackground: Color
    
    private let calendarColor = CalendarColor()
    
    init() {
        workingDayText = calendarColor.white
        restDayText = calendarColor.black
        
        workingDayBackground = calendarColor.graphite
        restDayBackground = calendarColor.white
    }
}

enum ColorPaletteToken: String {
    case user
    case monochrome
}

struct BaseColor {
    let inactive: Color = Color("inactive")
    let highlighted: Color = Color("highlighted")
    
    let accentPrimary: Color = Color("accentPrimary")
    let accentSecondary: Color = Color("accentSecondary")
    
    let contentPrimary: Color = Color("contentPrimary")
    let contentSecondary: Color = Color("contentSecondary")
    
    let themePrimary: Color = Color("themePrimary")
    let themeSecondary: Color = Color("themeSecondary")
    let themeTertiary: Color = Color("themeTertiary")
}

struct CalendarColor: PropertyIterable {
    let red: Color = Color("red")
    let redLight: Color = Color("redLight")
    
    let blue: Color = Color("blue")
    let blueLight: Color = Color("blueLight")
    
    let green: Color = Color("green")
    let greenLight: Color = Color("greenLight")
    
    let graphite: Color = Color("graphite")
    let black: Color = Color("black")
    
    let white: Color = Color("white")
    let clear: Color = .clear
}
