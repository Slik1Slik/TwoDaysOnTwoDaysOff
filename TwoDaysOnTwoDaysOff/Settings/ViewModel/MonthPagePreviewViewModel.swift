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
    
    //@Published var month: Date = Date().short
    var days: [Day] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func day(for date: Date) -> Day? {
        return self.days.filter { day in
            DateConstants.calendar.isDate(day.date, inSameDayAs: date)
        }.first
    }
    
    init() {
        let datesForMonth = DateConstants.calendar.generateDates(of: .month, for: Date().startOfDay)
        let schedule = Schedule(startDate: datesForMonth[0],
                                finalDate: datesForMonth[21],
                                countOfWorkingDays: UserSettings.countOfWorkingDays!,
                                countOfRestDays: UserSettings.countOfRestDays!)
        self.days = DaysDataStorageCreator.shared.generateDays(for: schedule)
    }
    
    //    init() {
    //        $month
    //            .map { date in
    //                let days = DateConstants.calendar.generateDates(of: .month, for: date)
    //                let schedule = Schedule(startDate: days[0], finalDate: days[21], countOfWorkingDays: UserSettings.countOfWorkingDays!, countOfRestDays: UserSettings.countOfRestDays!)
    //                print(days.count)
    //                return DaysDataStorageCreator.shared.generateDays(for: schedule)
    //            }
    //            .assign(to: \.days, on: self)
    //            .store(in: &cancellableSet)
    //    }
}
