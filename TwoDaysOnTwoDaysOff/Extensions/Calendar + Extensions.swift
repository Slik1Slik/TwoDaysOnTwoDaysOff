//
//  Calendar + Extensions.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 09.11.2021.
//

import Foundation

extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
    
    func generateDates(of component: Calendar.Component, for date: Date) -> [Date] {
        switch component {
        case .weekOfMonth:
            return generateDates(ofWeek: date)
        case .month:
            return generateDates(ofMonth: date)
        case .year:
            return generateDates(ofYear: date)
        default:
            return []
        }
    }
    
    private func generateDates(ofMonth month: Date) -> [Date] {
        guard
            let monthInterval = self.dateInterval(of: .month, for: month),
            let monthFirstWeek = self.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = self.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        let start = monthFirstWeek.start
        var end = monthLastWeek.end
        //if the month ends on Sunday the "monthLastWeek" date interval equals not the last week of the month as it should but the first week of the next month, which causes layout issues, so I've added this if-block to catch such case
        if monthInterval.end.allComponents().weekday! == 2 {
            end = monthInterval.end
        }
        return self.generateDates(
            inside: DateInterval(start: start, end: end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    private func generateDates(ofWeek week: Date) -> [Date] {
        guard let weekInterval = self.dateInterval(of: .weekOfMonth, for: week) else {
            return []
        }
        return self.generateDates(
            inside: DateInterval(start: weekInterval.start, end: weekInterval.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    private func generateDates(ofYear year: Date) -> [Date] {
        guard
            let yearInterval = self.dateInterval(of: .year, for: year)
        else { return [] }
        return self.generateDates(
            inside: DateInterval(start: yearInterval.start, end: yearInterval.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    func lastDateOf(month: Date) -> Date? {
        return self.date(byAdding: .day, value: -1, to: self.dateInterval(of: .month, for: month)?.end ?? Date())
    }
    
    func firstDateOf(month: Date) -> Date? {
        return self.dateInterval(of: .month, for: month)?.start
    }
    
    
}
