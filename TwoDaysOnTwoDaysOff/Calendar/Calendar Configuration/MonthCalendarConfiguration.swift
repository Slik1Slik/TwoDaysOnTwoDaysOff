//
//  MonthCalendarConfiguration.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.11.2021.
//

import Combine
import Foundation

class MonthCalendarConfiguration: ObservableObject {
    
    var calendar: Calendar
    @Published var month: Date = Date()
    @Published var selectedDate: Date = Date()
    
    init(calendar: Calendar, month: Date) {
        self.calendar = calendar
        self.month = month
    }
    
    init() {
        self.calendar = Calendar(identifier: .gregorian)
        self.month = Date()
    }
    
    init(calendar: Calendar, month: Date, initialDate: Date) {
        self.calendar = calendar
        self.month = month
        
        self.selectedDate = initialDate
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
        return calendar.generateDates(of: .month, for: month)
    }
    
    func weekdaySymbols() -> [String] {
        return calendar.locale?.identifier == "ru_RU" ? ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"] : calendar.shortStandaloneWeekdaySymbols
    }
}
