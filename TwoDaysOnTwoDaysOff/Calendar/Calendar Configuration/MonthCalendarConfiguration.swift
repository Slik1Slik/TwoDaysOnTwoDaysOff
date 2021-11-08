//
//  MonthCalendarConfiguration.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.11.2021.
//

import Foundation

struct MonthCalendarConfiguration {
    var calendar: Calendar
    var month: Date
    
    init(calendar: Calendar, month: Date) {
        self.calendar = calendar
        self.month = month
    }
    
    init() {
        self.calendar = Calendar(identifier: .gregorian)
        self.month = Date()
    }
    
    func weeks() -> [[Date]] {
        let daysForMonth = days()
        let numberOfWeeks = Int(daysForMonth.count / 7)
        var weeks = [[Date]]()
        
        var day = 0
        
        for _ in 0..<numberOfWeeks {
            var week = [Date]()
            for _ in 0..<7 {
                week.append(daysForMonth[day])
                day += 1
            }
            weeks.append(week)
        }
        return weeks
    }
    
    func days() -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    func weekdaySymbols() -> [String] {
        return calendar.locale?.identifier == "ru_RU" ? ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"] : calendar.shortStandaloneWeekdaySymbols
    }
}
