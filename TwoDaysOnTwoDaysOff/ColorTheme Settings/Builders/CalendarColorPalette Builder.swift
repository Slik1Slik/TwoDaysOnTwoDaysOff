//
//  CalendarColorPalette Builder.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI

class CalendarColorPaletteBuillder {
    static var user: CalendarColorPalette {
        let calendarColor = CalendarColor()
        let colorPalette = CalendarColorPalette()
        
        colorPalette.workingDayText = calendarColor.black
        colorPalette.restDayText = calendarColor.white
        
        colorPalette.workingDayBackground = Color(UserSettings.workingDayCellColor!)
        colorPalette.restDayBackground = Color(UserSettings.restDayCellColor!)
        
        return colorPalette
    }
    
    static var monochrome: CalendarColorPalette {
        return CalendarColorPalette()
    }
}
