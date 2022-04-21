//
//  DaysDataStorageLinker.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.04.2022.
//

import Foundation

class DaysExceptionsDataStorageLinker
{
    static func linkExceptionsTo(_ days: inout [Day])
    {
        guard ExceptionsDataStorageManager.shared.countOfObjects() != 0 else { return }
        let lastExceptionDate = ExceptionsDataStorageManager.shared.readAll().sorted { $0.to < $1.to }.last!.to
        let storageSearchBoundary = (0..<days.count).filter { index in
            DateConstants.calendar.isDate(days[index].date, inSameDayAs: lastExceptionDate)
        }.first ?? days.count
        for index in 0..<storageSearchBoundary
        {
            if let exception = ExceptionsDataStorageManager.shared.find(by: days[index].date) {
                days[index].exception = exception
                days[index].isWorking = exception.isWorking
            } else {
                continue
            }
        }
    }
}
