//
//  MonthCalendarManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.11.2021.
//

import Combine
import UIKit

class MonthCalendarManager: ObservableObject {
    
    private(set) var calendar: Calendar
    private(set) var interval: DateInterval
    
    @Published var currentMonth: Date = Date()
    @Published var selectedDate: Date = Date().short
    
    var layoutConfiguration: MonthCalendarLayoutConfiguration = MonthCalendarLayoutConfiguration()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    init() {
        self.calendar = Calendar(identifier: .gregorian)
        self.interval = DateInterval(start: Date(), end: Date())
        
        self.layoutConfiguration = MonthCalendarLayoutConfiguration()
    }
    
    init(calendar: Calendar,
         interval: DateInterval,
         currentMonth: Date,
         initialDate: Date,
         layoutConfiguration: @escaping (MonthCalendarLayoutConfiguration) -> ())
    {
        self.calendar = calendar
        self.interval = interval
        
        self.currentMonth = currentMonth
        self.selectedDate = initialDate
        
        layoutConfiguration(self.layoutConfiguration)
        
    }
    
    init(calendar: Calendar,
         interval: DateInterval,
         currentMonth: Date? = nil,
         initialDate: Date? = nil,
         layoutConfiguration: @escaping (MonthCalendarLayoutConfiguration) -> ())
    {
        self.calendar = calendar
        self.interval = interval
        
        self.currentMonth = interval.start
        
        layoutConfiguration(self.layoutConfiguration)
        
        self.selectedDate = initialDate ?? Date().short
        
        guard let currentMonth = currentMonth else {
            self.currentMonth = interval.start
            return
        }
        self.currentMonth = currentMonth
    }
    
    convenience init(calendar: Calendar,
         interval: DateInterval,
         currentMonth: Date? = nil,
         initialDate: Date? = nil,
         layoutConfiguration: LayoutConfiguration)
    {
        var initialWidth: CGFloat
        
        switch layoutConfiguration {
        case .expanded:
            initialWidth = UIScreen.main.bounds.width
        case .alert:
            initialWidth = UIScreen.main.bounds.width / 1.5
        }
        
        self.init(calendar: calendar,
                  interval: interval,
                  currentMonth: currentMonth,
                  initialDate: initialDate) { config in
            config.width = initialWidth
        }
    }
}

extension MonthCalendarManager {
    func calendarConfiguration(for month: Date) -> MonthCalendarConfiguration {
        return MonthCalendarConfiguration(calendar: self.calendar, month: month)
    }
    
    func calendarConfigurationForCurrentMonth() -> MonthCalendarConfiguration {
        return calendarConfiguration(for: self.currentMonth)
    }
}

extension MonthCalendarManager {
    enum LayoutConfiguration {
        case expanded
        case alert
    }
}
