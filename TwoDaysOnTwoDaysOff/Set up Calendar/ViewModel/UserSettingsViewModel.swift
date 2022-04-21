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
    @Published var startDate = UserSettings.isCalendarFormed! ? UserSettings.startDate : Date().short
    @Published var finalDate = Date()
    @Published var countOfWorkingDays = 0
    @Published var countOfRestDays = 0
    
    @Published var colorsErrorMessage = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    init()
    {
        $startDate
            .map { date in
                return DateConstants.calendar.date(byAdding: .year, value: 1, to: date) ?? date.addingTimeInterval(Double(DateConstants.dayInSeconds)*366)
            }
            .assign(to: \.finalDate, on: self)
            .store(in: &cancellableSet)
    }
    
    func saveUserSettings()
    {
        UserSettings.startDate = self.startDate
        UserSettings.finalDate = self.finalDate

        UserSettings.countOfWorkingDays = self.countOfWorkingDays + 1
        UserSettings.countOfRestDays = self.countOfRestDays + 1

        UserSettings.isCalendarFormed = true
    }
}
