//
//  MonthPagePreviewViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.04.2022.
//

import Foundation
import SwiftUI
import Combine

class MonthPagePreviewViewModel: ObservableObject {
    
    var days: [Day] = []
    
    func day(for date: Date) -> Day? {
        return self.days.filter { day in
            DateConstants.calendar.isDate(day.date, inSameDayAs: date)
        }.first
    }
    
    init() {
        let datesForMonth = DateConstants.calendar.generateDates(of: .month, for: Date().startOfDay)
        let schedule = Schedule(startDate: datesForMonth[0],
                                finalDate: datesForMonth[20],
                                countOfWorkingDays: UserSettings.countOfWorkingDays ?? 2,
                                countOfRestDays: UserSettings.countOfRestDays ?? 2)
        self.days = DaysDataStorageCreator.shared.generateDays(for: schedule)
    }
}
