//
//  UserSettingsObserver.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.04.2022.
//

import Combine
import SwiftUI

class UserSettingsObserver: ObservableObject {
    
    @Published private(set) var isCalendarFormed: Bool = false
    
    @Published private(set) var colorPalette: ColorPalette = ColorPalette()
    @Published private(set) var calendarColorPalette: CalendarColorPalette = CalendarColorPalette()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        UserDefaults.standard
            .publisher(for: \.colorThemeID)
            .sink { [weak self] _ in
                self?.colorPalette = ApplicationColorPalette.shared
                self?.calendarColorPalette = ApplicationColorPalette.calendar
            }
            .store(in: &cancellableSet)
        
        UserDefaults.standard
            .publisher(for: \.isCalendarFormed)
            .map { return $0 }
            .assign(to: \.isCalendarFormed, on: self)
            .store(in: &cancellableSet)
    }
}

extension UserDefaults {
    @objc dynamic var isCalendarFormed: Bool {
        get {
            return bool(forKey: UserSettings.SettingsKeys.isCalendarFormed.rawValue)
        }
    }
    
    @objc dynamic var colorThemeID: String {
        get {
            return string(forKey: UserSettings.SettingsKeys.colorThemeID.rawValue) ?? DefaultColorTheme.monochrome.rawValue
        }
    }
}
