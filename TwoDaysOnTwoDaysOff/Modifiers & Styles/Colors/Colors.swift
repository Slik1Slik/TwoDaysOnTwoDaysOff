//
//  Colors.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.03.2022.
//

import Foundation
import SwiftUI

protocol ColorPalette {
    var buttonPrimary: Color { get }
    var buttonSecondary: Color { get }
    var buttonInactive: Color { get }
    var buttonHighlighted: Color { get }
    
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    
    var backgroundDefault: Color { get }
    var backgroundForm: Color { get }
    var backgroundTable: Color { get }
}

class ApplicationColorPalette {
    static var shared: ColorPalette {
        switch UserSettings.colorPaletteToken {
        case .user: return UserColorPalette()
        case .monochrome: return MonochromeColorPalette()
        }
    }
    
    static var monthCalendar: MonthCalendarColorPalette {
        switch UserSettings.colorPaletteToken {
        case .user: return MonthCalendarUserColorPalette()
        case .monochrome: return MonthCalendarMonochromeColorPalette()
        }
    }
}

class UserColorPalette: ColorPalette {
    var buttonPrimary: Color = Color(UserSettings.restDayCellColor!)
    var buttonSecondary: Color = .primary
    var buttonInactive: Color = .secondary
    var buttonHighlighted: Color = .white
    
    var textPrimary: Color = .primary
    var textSecondary: Color = .secondary
    
    var backgroundDefault: Color = .white
    var backgroundForm: Color = Color(.systemGray6)
    var backgroundTable: Color = .gray.opacity(0.04)
}

class MonochromeColorPalette: ColorPalette {
    var buttonPrimary: Color = .blue
    var buttonSecondary: Color = .primary
    var buttonInactive: Color = .secondary
    var buttonHighlighted: Color = .white
    
    var textPrimary: Color = .primary
    var textSecondary: Color = .secondary
    
    var backgroundDefault: Color = .white
    var backgroundForm: Color = Color(.systemGray6)
    var backgroundTable: Color = .gray.opacity(0.04)
}

protocol MonthCalendarColorPalette {
    var workingDayText: Color { get }
    var restDayText: Color { get }
    
    var workingDayBackground: Color { get }
    var restDayBackground: Color { get }
}

class MonthCalendarUserColorPalette: MonthCalendarColorPalette {
    var workingDayText: Color {
        return .primary
    }
    
    var restDayText: Color {
        return .white
    }
    
    var workingDayBackground: Color {
        return Color(UserSettings.workingDayCellColor!)
    }
    
    var restDayBackground: Color {
        return Color(UserSettings.restDayCellColor!)
    }
}

class MonthCalendarMonochromeColorPalette: MonthCalendarColorPalette {
    var workingDayText: Color {
        return .white
    }
    
    var restDayText: Color {
        return .primary
    }
    
    var workingDayBackground: Color {
        return .primary.opacity(0.8)
    }
    
    var restDayBackground: Color {
        return .clear
    }
}

enum ColorPaletteToken: String {
    case user = "user"
    case monochrome = "monochrome"
}
