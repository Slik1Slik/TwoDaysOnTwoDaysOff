//
//  Date + Extensions.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

extension Date {
    
    func string() -> String {
        
        let dateFormatter = DateConstants.dateFormatter
        return dateFormatter.string(from: self)
    }
    
    func string(format: String) -> String {
        let dateFormatter = DateConstants.dateFormatter
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Date {
    
    init?(from string: String)
    {
        self.init()
        
        let dateFormatter = DateConstants.dateFormatter
        
        guard let date = dateFormatter.date(from: string) else {return}
        
        self = date
    }
}

extension Date {
    
    func monthAndYear() -> DateComponents {
        let calendar = DateConstants.calendar
        let components = calendar.dateComponents([.month, .year], from: self)
        
        return components
    }
    
    func baseComponents() -> DateComponents
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        
        return components
    }
    
    func allComponents() -> DateComponents
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: DateConstants.timeZone, from: self)
        
        return components
    }
    
    var day: Int?
    {
        get {
            return self.baseComponents().day
        }
    }
    
    var month: Int?
    {
        get {
            return self.baseComponents().month
        }
    }
    
    var year: Int?
    {
        get {
            return self.baseComponents().year
        }
    }
}

extension Date {
    
    func short() -> Date
    {
        let dateFormatter = DateConstants.dateFormatter
        
        let string = dateFormatter.string(from: self)
        
        return Date(from: string)!
    }
    
    func monthSymbolAndYear() -> String
    {
        let calendar = DateConstants.calendar
        let components = self.baseComponents()
        let numberOfMonth = components.month!
        let year = components.year!
        
        return calendar.standaloneMonthSymbols[numberOfMonth - 1].capitalized + " " + year.description
    }
    
    func dayNumberAndMonthSymbol() -> String
    {
        let calendar = DateConstants.calendar
        let components = self.baseComponents()
        let numberOfDay = components.day!.description
        let monthSymbol = calendar.shortStandaloneMonthSymbols[components.month! - 1]
        
        return numberOfDay + " " + monthSymbol
    }
}

extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM-yyyy"
        return formatter
    }
}

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
}

extension Date
{
    func isContained(fromDate: Date, toDate: Date) -> Bool
    {
        let range = fromDate...toDate
        
        return range.contains(self)
    }
}
