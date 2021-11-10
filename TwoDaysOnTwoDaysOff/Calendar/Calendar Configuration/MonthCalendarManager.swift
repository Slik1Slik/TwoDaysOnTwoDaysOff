//
//  MonthCalendarManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.11.2021.
//

import Combine
import UIKit

class MonthCalendarManager: ObservableObject {
    var calendarConfiguration: MonthCalendarConfiguration = MonthCalendarConfiguration()
    var layoutConfiguration: MonthCalendarLayoutConfiguration = MonthCalendarLayoutConfiguration()
    
    @Published var selectedDate: Date?
    @Published var currentMonth: Date = Date()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        self.calendarConfiguration = MonthCalendarConfiguration()
        self.layoutConfiguration = MonthCalendarLayoutConfiguration()
        
        setSubscriptions()
    }
    
    init(initialDate: Date,
         calendar: Calendar,
         layoutConfiguration: @escaping (MonthCalendarLayoutConfiguration) -> ())
    {
        self.selectedDate = initialDate
        self.calendarConfiguration = MonthCalendarConfiguration(calendar: calendar, month: initialDate)
        layoutConfiguration(self.layoutConfiguration)
        self.currentMonth = initialDate
        
        setSubscriptions()
    }
    
    init(initialDate: Date, calendar: Calendar, layoutConfiguration: LayoutConfiguration) {
        self.selectedDate = initialDate
        self.calendarConfiguration = MonthCalendarConfiguration(calendar: calendar, month: initialDate)
        self.currentMonth = initialDate
        
        switch layoutConfiguration {
        case .expanded:
            self.layoutConfiguration = MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width)
        case .alert:
            self.layoutConfiguration = MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width / 1.2)
        }
        
        setSubscriptions()
    }
    
    private func setSubscriptions() {
        $currentMonth
            .receive(on: RunLoop.main)
            .sink { month in
                self.calendarConfiguration.month = month
            }
            .store(in: &cancellableSet)
    }
}

extension MonthCalendarManager {
    enum LayoutConfiguration {
        case expanded
        case alert
    }
}
