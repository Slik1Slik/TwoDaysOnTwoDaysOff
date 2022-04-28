//
//  YearCalendarPageViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 26.04.2022.
//

import Combine
import SwiftUI

class YearCalendarPageViewModel: ObservableObject {
    
    @Published var year: Date = Date().startOfDay
    @Published var days: [Day] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func intervalContains(month: Date) -> Bool {
        let calendar = DateConstants.calendar
        guard let lastDateOfMonth = calendar.lastDateOf(month: month),
              let firstDateOfMonth = calendar.firstDateOf(month: month) else {
            return false
        }
        return lastDateOfMonth.isContained(fromDate: days.first!.date, toDate: days.last!.date) || firstDateOfMonth.isContained(fromDate: days.first!.date, toDate: days.last!.date)
    }
    
    init() {
        $year
            .map { date in
                UserDaysDataStorageManager.shared.find(by: .year(date))
            }
            .assign(to: \.days, on: self)
            .store(in: &cancellableSet)
    }
}
