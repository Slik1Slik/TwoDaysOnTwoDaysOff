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
    @Published var startDate = UserSettings.isCalendarFormed! ? UserSettings.startDate : Date() {
        willSet {
            finalDate = newValue.addingTimeInterval(Double(DateConstants.dayInSeconds)*365)
        }
    }
    @Published var finalDate = Date()
    @Published var countOfWorkingDays = 0
    @Published var countOfRestDays = 0
    @Published var restDayColor = UserSettings.isCalendarFormed! ? UserSettings.restDayCellColor : "white"
    @Published var workingDayColor = UserSettings.isCalendarFormed! ? UserSettings.workingDayCellColor : "black"
    
    @Published var colorsErrorMessage = ""
    
    @Published var isValid = false
    @Published var areColorsValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var areColorsSpecified: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($workingDayColor, $restDayColor)
            .map {
                return !(($0 == "black") || ($1 == "white"))
            }
            .eraseToAnyPublisher()
    }
    
    private var areColorsEqual: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($workingDayColor, $restDayColor)
            .map {
                return $0 == $1
            }
            .eraseToAnyPublisher()
    }
    
    private var areColorsValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(areColorsSpecified, areColorsEqual)
            .map {
                return $0 && !$1
            }
            .eraseToAnyPublisher()
    }
    
    private var areSettingsValid: AnyPublisher<Bool, Never> {
        areColorsValidPublisher
            .eraseToAnyPublisher()
    }
    
    init()
    {
        areColorsEqual
            .map {equal in
                return equal ? "Цвета дней не должны совпадать" : ""
            }
            .assign(to: \.colorsErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        areSettingsValid
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func saveUserSettings()
    {
        UserSettings.startDate = self.startDate
        UserSettings.finalDate = self.finalDate

        UserSettings.countOfWorkingDays = self.countOfWorkingDays + 1
        UserSettings.countOfRestDays = self.countOfRestDays + 1

        UserSettings.workingDayCellColor = self.workingDayColor
        UserSettings.restDayCellColor = self.restDayColor

        UserSettings.isCalendarFormed = true
    }
}
