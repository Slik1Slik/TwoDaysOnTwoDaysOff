//
//  MonthPageDayViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 21.03.2022.
//

import Foundation
import SwiftUI
import Combine

class MonthCalendarPageViewModel: ObservableObject {
    
    @Published var month: Date = Date().startOfDay
    @Published var days: [Day] = []
    
    @ObservedObject private var exceptionsObserver = RealmObserver(for: Exception.self)
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func day(for date: Date) -> Day? {
        return self.days.filter { day in
            DateConstants.calendar.isDate(day.date, inSameDayAs: date)
        }.first
    }
    
    init() {
        $month
            .map { date in
                UserDaysDataStorageManager.shared.find(by: .month(date))
            }
            .assign(to: \.days, on: self)
            .store(in: &cancellableSet)
        
        exceptionsObserver.onObjectsDidChange = { [unowned self] in
            self.month = self.month
        }
    }
}
