//
//  MonthCalendarManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.11.2021.
//

import Combine
import UIKit

class CalendarManager: ObservableObject {
    
    private(set) var calendar: Calendar = Calendar.current
    private(set) var interval: DateInterval = .init()
    
    var currentDate: Date {
        Date().startOfDay
    }
    
    @Published var selectedDate: Date = Date().startOfDay
    @Published var selectedMonth: Date = Date().startOfDay
    @Published var selectedYear: Date = Date().startOfDay
    
    var layoutConfiguration: CalendarLayoutConfiguration = CalendarLayoutConfiguration()
    
    var dates: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var quarters: [[Date]] {
        var result: [[Date]] = [[]]
        let months = self.months
        var monthIndex = 0
        for _ in 0..<4 {
            var quarter: [Date] = []
            for _ in 0..<3 {
                quarter.append(months[monthIndex])
                monthIndex += 1
            }
            result.append(quarter)
        }
        return result
    }
    
    var years: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(month: 1, day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    func isDateCurrent(_ date: Date) -> Bool {
        return calendar.isDate(date, inSameDayAs: currentDate)
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    func isMonthCurrent(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    func isYearCurrent(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: currentDate, toGranularity: .year)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        self.calendar = Calendar(identifier: .gregorian)
        self.interval = DateInterval(start: Date(), end: Date())
        
        self.layoutConfiguration = CalendarLayoutConfiguration()
    }
    
    init(calendar: Calendar,
         interval: DateInterval,
         initialDate: Date,
         layoutConfiguration: @escaping (CalendarLayoutConfiguration) -> ())
    {
        self.calendar = calendar
        self.interval = interval
        
        self.selectedDate = initialDate
        self.selectedMonth = initialDate
        self.selectedYear = initialDate
        
        layoutConfiguration(self.layoutConfiguration)
    }
    
    init(calendar: Calendar,
         interval: DateInterval,
         initialDate: Date? = nil,
         layoutConfiguration: @escaping (CalendarLayoutConfiguration) -> ())
    {
        self.calendar = calendar
        self.interval = interval
        
        self.selectedDate = interval.start
        self.selectedMonth = interval.start
        self.selectedYear = interval.start
        
        layoutConfiguration(self.layoutConfiguration)
        
        self.selectedDate = initialDate ?? Date().startOfDay
    }
    
    convenience init(calendar: Calendar,
         interval: DateInterval,
         initialDate: Date? = nil,
         layoutConfiguration: LayoutConfiguration)
    {
        let initialWidth: CGFloat = layoutConfiguration.width
        
        self.init(calendar: calendar,
                  interval: interval,
                  initialDate: initialDate) { config in
            config.width = initialWidth
        }
    }
    
    convenience init(calendar: Calendar,
        interval: Interval,
        initialDate: Date? = nil,
        layoutConfiguration: @escaping (CalendarLayoutConfiguration) -> ())
   {
       
       var dateInterval = DateInterval()
       
       switch interval {
       case .month(let date):
           let dates = calendar.generateDates(of: .month, for: date)
           dateInterval = DateInterval(start: dates.first!, end: dates.last!)
       case .year(let date):
           let dates = calendar.generateDates(of: .year, for: date)
           dateInterval = DateInterval(start: dates.first!, end: dates.last!)
       }
       
       self.init(calendar: calendar,
                 interval: dateInterval,
                 initialDate: initialDate,
                 layoutConfiguration: layoutConfiguration)
   }
}

extension CalendarManager {
    func calendarConfiguration(for month: Date) -> MonthCalendarConfiguration {
        return MonthCalendarConfiguration(calendar: self.calendar, month: month)
    }
    
    func calendarConfigurationForCurrentMonth() -> MonthCalendarConfiguration {
        return calendarConfiguration(for: self.currentDate)
    }
}

extension CalendarManager {
    enum LayoutConfiguration {
        case expanded
        case alert
        
        var width: CGFloat {
            switch self {
            case .expanded:
                return UIScreen.main.bounds.width
            case .alert:
                return UIScreen.main.bounds.width / 1.5
            }
        }
    }
}

extension CalendarManager {
    enum Interval {
        case month(Date)
        case year(Date)
    }
}
