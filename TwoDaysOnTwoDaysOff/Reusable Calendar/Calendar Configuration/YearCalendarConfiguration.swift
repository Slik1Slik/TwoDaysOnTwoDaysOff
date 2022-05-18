//
//  YearCalendarConfiguration.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.04.2022.
//

import Foundation

class YearCalendarConfiguration {
    
    var calendar: Calendar
    var year: Date = Date()
    
    init(calendar: Calendar, year: Date) {
        self.calendar = calendar
        self.year = year
    }
    
    init() {
        self.calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        self.year = Date()
    }
    
    var months: [Date] {
        let dates = calendar.generateDates(of: .year, for: year)
        let dateInterval = DateInterval(start: dates.first!, end: dates.last!)
        
        return calendar.generateDates(
            inside: dateInterval,
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
}
