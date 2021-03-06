//
//  UserSettingsViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import Combine
import SwiftUI

class UserSettingsViewModel: ObservableObject
{
    @Published var startDate = UserSettings.isCalendarFormed! ? UserSettings.startDate : Date().startOfDay
    @Published var finalDate = Date()
    @Published var countOfWorkingDays = 2
    @Published var countOfRestDays = 2
    
    func dropCurrentUserSettings() {
        UserSettings.isCalendarFormed = false
        try? ExceptionsDataStorageManager.shared.removeAll()
    }
    
    func saveUserSettings()
    {
        UserSettings.startDate = self.startDate
        UserSettings.finalDate = DateConstants.calendar.date(byAdding: .year, value: 1, to: self.startDate) ?? self.startDate.addingTimeInterval(Double(DateConstants.dayInSeconds) * 366)
        
        UserSettings.countOfWorkingDays = self.countOfWorkingDays
        UserSettings.countOfRestDays = self.countOfRestDays
        
        UserSettings.isCalendarFormed = true
    }
}
