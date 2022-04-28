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
        
        let newExceptions = ExceptionsDataStorageManager.shared.readAll().filter(NSPredicate(format: "to >= %@", argumentArray: [Date().startOfDay]))
        
        guard !newExceptions.isEmpty else { return }
        
        let lastExceptionDate = newExceptions.sorted { $0.to < $1.to }.last!.to
        
        var storageSearchBoundary = days.count
        
        if let lastDayWithExceptionIndex = (0..<days.count).filter({ index in
            DateConstants.calendar.isDate(days[index].date, inSameDayAs: lastExceptionDate)
        }).first
        {
            storageSearchBoundary = lastDayWithExceptionIndex + 1
        }
        
        for index in 0..<storageSearchBoundary
        {
            if let exception = ExceptionsDataStorageManager.shared.find(by: days[index].date) {
                days[index].exception = exception
            } else {
                continue
            }
        }
    }
}
