//
//  DaysDataStoraDaysDataStorageReadergeManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class UserDaysDataStorageManager
{
    private let schedule: Schedule
    private let calendar = DateConstants.calendar

    class var shared: UserDaysDataStorageManager {
        get {
            return UserDaysDataStorageManager()
        }
    }

    private(set) var storage: [Day]

    func find(by date: Date) -> Day? {
        storage.filter { calendar.isDate(date, inSameDayAs: $0.date) }.first
    }

    func find(by option: IntervalSearchOption) -> [Day] {
        switch option {
        case .day(let date):
            guard let day = find(by: date) else { return [] }
            return [day]
        case .month(let month):
            return storage.filter { calendar.isDate($0.date, equalTo: month, toGranularity: .month) }
        case .year(let year):
            return storage.filter { calendar.isDate($0.date, equalTo: year, toGranularity: .year) }
        case .interval(let dateInterval):
            return storage.filter { dateInterval.contains($0.date) }
        }
    }
    
    func updateStorage() {
        guard let isCalendarFormed = UserSettings.isCalendarFormed,
              isCalendarFormed == true,
              schedule.startDate < Date().short,
              let currentDay = find(by: Date()),
              currentDay.isWorking,
              let dateBefore = calendar.date(byAdding: .day, value: -1, to: Date()),
              let dayBefore = find(by: dateBefore),
              !dayBefore.isWorking
        else { return }
        
        UserSettings.startDate = Date().short
        UserSettings.finalDate = DateConstants.calendar.date(byAdding: .year, value: 1, to: Date().short) ?? Date().short.addingTimeInterval(Double(DateConstants.dayInSeconds)*366)
    }

    init() {
        self.schedule = Schedule(startDate: UserSettings.startDate,
                                 finalDate: UserSettings.finalDate,
                                 countOfWorkingDays: UserSettings.countOfWorkingDays!,
                                 countOfRestDays: UserSettings.countOfRestDays!)

        self.storage = DaysDataStorageCreator.shared.generateDays(for: schedule)
        
        DaysExceptionsDataStorageLinker.linkExceptionsTo(&self.storage)
    }
}

enum IntervalSearchOption {
    case day(Date)
    case month(Date)
    case year(Date)
    case interval(DateInterval)
}
