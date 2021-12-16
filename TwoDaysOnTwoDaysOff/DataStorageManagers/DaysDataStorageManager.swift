//
//  DaysDataStorageManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class DaysDataStorageManager
{
    static private let fromDate: Date = UserSettings.startDate
    static private let toDate: Date = UserSettings.finalDate
    
    static private let countOfWorkingDays: Int = UserSettings.countOfWorkingDays!
    static private let countOfRestDays: Int = UserSettings.countOfRestDays!
    
    static private let calendar = DateConstants.calendar
    
    static let storage: [Day] = {
        let days = getDays()
        
        let filtredDays = filterDays(days)
        
        let finalDays = setExceptions(for: filtredDays)
        
        return finalDays
    }()
    
    static func find(by date: Date) -> Day?
    {
        let day = storage.filter {
            return calendar.isDate(date, inSameDayAs: $0.date)
        }
        return day.first
    }
    
    static func find(interval: DateInterval) -> [Day] {
        storage
            .filter { day in
                interval.contains(day.date)
            }
    }
    
    static private func getParsedDays() -> [Day]
    {
        let days = getDays()
        
        let filtredDays = filterDays(days)
        
        let finalDays = setExceptions(for: filtredDays)
        return finalDays
    }
    
    static private func getDays() -> [Day]
    {
        var days = [Day]()
        
        let interval = toDate.timeIntervalSince(fromDate)
        
        var indexOfEachDay = 0.0
        
        while indexOfEachDay <= interval
        {
            let date = Date(timeInterval: indexOfEachDay, since: fromDate)
            days.append(Day(date: date.short()))
            
            indexOfEachDay += 60*60*24
        }
        return days
    }
    
    
    static private func filterDays(_ daysToFilter: [Day]) -> [Day]
    {
        var days = daysToFilter
        
        var indexOfEachDay = 0
        var indexOfWorkingDay = 0
        
        var index = 0
        
        while indexOfEachDay <= days.count
        {
            index = indexOfEachDay
            
            while indexOfWorkingDay < countOfWorkingDays
            {
                guard index < days.count else {return days}
                
                days[index].isWorking.toggle()
                indexOfWorkingDay += 1
                index += 1
            }
            
            indexOfWorkingDay = 0
            indexOfEachDay += countOfWorkingDays
            
            indexOfEachDay += countOfRestDays
        }
        
        return days
    }
    
    static private func setExceptions(for days: [Day]) -> [Day]
    {
        guard ExceptionsDataStorageManager.shared.countOfObjects() != 0 else {
            return days
        }
        
        var filtredDays = days
        
        for index in 0..<filtredDays.count
        {
            //guard filtredDays[index].date <= ExceptionsDataStorageManager.readAll().last!.to else {return filtredDays}
            let exception = ExceptionsDataStorageManager.shared.find(by: filtredDays[index].date)
            if let exception = exception {
                filtredDays[index].exception = exception
                filtredDays[index].isWorking = exception.isWorking
            } else {
                continue
            }
        }
        return filtredDays
    }
    
}

enum DaysDataStorageManagerErrors: Error
{
    case CalendarHasNotBeenFormed
}
