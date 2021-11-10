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
        return self.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
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
            let yearInterval = self.dateInterval(of: .year, for: year),
            let yearFirstWeek = self.dateInterval(of: .weekOfYear, for: yearInterval.start),
            let yearLastWeek = self.dateInterval(of: .weekOfYear, for: yearInterval.end)
        else { return [] }
        return self.generateDates(
            inside: DateInterval(start: yearFirstWeek.start, end: yearLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
}
