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

    static let shared: DaysDataStorageCreator = DaysDataStorageCreator()

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
            .generateDates(inside: DateInterval(start: schedule.startDate, end: schedule.finalDate.endOfDay),
                                      matching: DateComponents(hour: 0, minute: 0, second: 0))
            .map { Day(date: $0, isWorking: false, exception: nil) }
        if storage.isEmpty {
            createDays()
        }
    }

    private func mapDays()
    {
        var eachDayIndex = 0
        var workingDayIndex = schedule.countOfWorkingDays
        
        while eachDayIndex < storage.count {
            if eachDayIndex < workingDayIndex {
                storage[eachDayIndex].isWorking.toggle()
                eachDayIndex += 1
            } else {
                workingDayIndex += schedule.countOfWorkingDays + schedule.countOfRestDays
                eachDayIndex += schedule.countOfRestDays
            }
        }
    }

    private init() {
    }
}
