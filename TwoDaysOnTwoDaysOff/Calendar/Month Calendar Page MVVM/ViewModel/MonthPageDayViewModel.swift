//
//  MonthPageDayViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 21.03.2022.
//

import Foundation
import SwiftUI
import Combine

class MonthPageDayViewModel: ObservableObject {
    
    @Published var month: Date = Date().short
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
                DaysDataStorageManager.shared.find(interval: DateConstants.calendar.dateInterval(of: .month, for: date)!)
            }
            .assign(to: \.days, on: self)
            .store(in: &cancellableSet)
        
        exceptionsObserver.onObjectsHaveBeenChanged = { [unowned self] in
            self.month = self.month
        }
    }
}
