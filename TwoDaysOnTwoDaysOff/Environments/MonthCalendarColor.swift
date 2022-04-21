//
//  MonthCalendarColor.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 23.03.2022.
//

import SwiftUI

private struct CalendarColorPaletteKey: EnvironmentKey {
    static let defaultValue: CalendarColorPalette = CalendarColorPalette()
}

extension EnvironmentValues {
    var calendarColorPalette: CalendarColorPalette {
        get { self[CalendarColorPaletteKey.self] }
        set { self[CalendarColorPaletteKey.self] = newValue }
    }
}
