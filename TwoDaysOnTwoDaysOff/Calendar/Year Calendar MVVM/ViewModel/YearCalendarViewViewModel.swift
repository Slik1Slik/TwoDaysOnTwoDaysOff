//
//  YearCalendarPageViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 26.04.2022.
//

import Combine
import SwiftUI

class YearCalendarViewViewModel: ObservableObject {
    
    var days: [Day] = UserDaysDataStorageManager.shared.storage
    
    func intervalContains(month: Date) -> Bool {
        let calendar = DateConstants.calendar
        guard let lastDateOfMonth = calendar.lastDateOf(month: month),
              let firstDateOfMonth = calendar.firstDateOf(month: month),
              !days.isEmpty else {
            return false
        }
        return lastDateOfMonth.isContained(fromDate: days.first!.date, toDate: days.last!.date) || firstDateOfMonth.isContained(fromDate: days.first!.date, toDate: days.last!.date)
    }
}
