//
//  DaysDataStorageCreator.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.04.2022.
//

import Foundation

class DaysDataStorageCreator
{
    var schedule: Schedule!

    class var shared: DaysDataStorageCreator {
         DaysDataStorageCreator()
    }

    private var storage: [Day] = []

    func generateDays(for schedule: Schedule) -> [Day] {
        self.schedule = schedule
        createDays()
        mapDays()
        return storage
    }

    private func createDays()
    {
        storage = DateConstants.calendar
            .generateDates(inside: DateInterval(start: schedule.startDate, end: schedule.finalDate),
                                      matching: DateComponents(hour: 0, minute: 0, second: 0))
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
            
            while indexOfWorkingDay < schedule.countOfWorkingDays
            {
                guard index < storage.count else { return }
                
                storage[index].isWorking.toggle()
                indexOfWorkingDay += 1
                index += 1
            }
            
            indexOfWorkingDay = 0
            indexOfEachDay += schedule.countOfWorkingDays + schedule.countOfRestDays
        }
    }

    init() {
    }
}
