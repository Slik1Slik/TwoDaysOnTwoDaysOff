//
//  MonthCalendarColor.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 23.03.2022.
//

import SwiftUI

private struct MonthCalendarColorPaletteKey: EnvironmentKey {
    static let defaultValue: MonthCalendarColorPalette = MonthCalendarMonochromeColorPalette()
}

extension EnvironmentValues {
    var monthCalendarColorPalette: MonthCalendarColorPalette {
        get { self[MonthCalendarColorPaletteKey.self] }
        set { self[MonthCalendarColorPaletteKey.self] = newValue }
    }
}
