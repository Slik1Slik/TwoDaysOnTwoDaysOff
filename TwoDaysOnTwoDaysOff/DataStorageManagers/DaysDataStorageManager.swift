//
//  DaysDataStorageManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class DaysDataStorageManager
{
    private let fromDate: Date = UserSettings.startDate
    private let toDate: Date = UserSettings.finalDate
    
    private let countOfWorkingDays: Int = UserSettings.countOfWorkingDays!
    private let countOfRestDays: Int = UserSettings.countOfRestDays!
    
    private let calendar = DateConstants.calendar
    
    class var shared: DaysDataStorageManager {
        get {
            return DaysDataStorageManager()
        }
    }
    
    var storage: [Day] = []
    
    func find(by date: Date) -> Day? {
        storage.filter { calendar.isDate(date, inSameDayAs: $0.date) }.first
    }
    
    func find(interval: DateInterval) -> [Day] {
        storage.filter { interval.contains($0.date) }
    }
    
    func updateStorage() {
        
        guard let isCalendarFormed = UserSettings.isCalendarFormed,
              isCalendarFormed == true,
              fromDate < Date().short,
              let currentDay = find(by: Date()),
              currentDay.isWorking,
              let dateBefore = calendar.date(byAdding: .day, value: -1, to: Date()),
              let dayBefore = find(by: dateBefore),
              !dayBefore.isWorking
        else { return }
        
        UserSettings.startDate = Date().short
        UserSettings.finalDate = DateConstants.calendar.date(byAdding: .year, value: 1, to: Date().short) ?? Date().short.addingTimeInterval(Double(DateConstants.dayInSeconds)*366)
    }
    
    private func generateDays()
    {
        storage = DateConstants.calendar
            .generateDates(inside: DateInterval(start: fromDate, end: toDate),
                                                       matching:  DateComponents(hour: 0, minute: 0, second: 0))
            .map { Day(date: $0, isWorking: false, exception: nil) }
    }
    
    private func mapDays()
    {
        var indexOfEachDay = 0
        var indexOfWorkingDay = 0
        
        var index = 0
        
        while indexOfEachDay < storage.count
        {
            index = indexOfEachDay
            
            while indexOfWorkingDay < countOfWorkingDays
            {
                guard index < storage.count else { return }
                
                storage[index].isWorking.toggle()
                indexOfWorkingDay += 1
                index += 1
            }
            
            indexOfWorkingDay = 0
            indexOfEachDay += countOfWorkingDays + countOfRestDays
        }
    }
    
    private func setExceptions()
    {
        guard ExceptionsDataStorageManager.shared.countOfObjects() != 0 else {
            return
        }
        let lastExceptionDate = ExceptionsDataStorageManager.shared.readAll().sorted { $0.to < $1.to }.last!.to
        let storageSearchBoundary = (0..<storage.count).filter { index in
            calendar.isDate(storage[index].date, inSameDayAs: lastExceptionDate)
        }.first!
        for index in 0...storageSearchBoundary
        {
            if let exception = ExceptionsDataStorageManager.shared.find(by: storage[index].date) {
                storage[index].exception = exception
            } else {
                continue
            }
        }
    }
    
    init() {
        generateDays()
        mapDays()
        setExceptions()
    }
}

enum DaysDataStorageManagerErrors: Error
{
    case CalendarHasNotBeenFormed
}
