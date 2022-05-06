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
    
    var dayNumber: Int?
    {
        get {
            return self.baseComponents().day
        }
    }
    
    var monthNumber: Int?
    {
        get {
            return self.baseComponents().month
        }
    }
    
    var yearNumber: Int?
    {
        get {
            return self.baseComponents().year
        }
    }
}

extension Date {
    
    var startOfDay: Date
    {
        get {
            var components = self.allComponents()
            
            components.day = self.dayNumber
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            
            return Calendar.current.date(from: components) ?? Calendar.current.startOfDay(for: self)
        }
    }
    
    var endOfDay: Date
    {
        get {
            var components = self.allComponents()
            
            components.day = self.dayNumber
            components.hour = 23
            components.minute = 59
            components.second = 59
            
            return Calendar.current.date(from: components) ?? Calendar.current.startOfDay(for: self)
        }
    }
    
    func monthSymbol(_ type: MonthSymbolType) -> String {
        let calendar = DateConstants.calendar
        switch type {
        case .monthSymbol:
            return calendar.monthSymbols[self.monthNumber! - 1]
        case .shortMonthSymbol:
            return calendar.shortMonthSymbols[self.monthNumber! - 1]
        case .standaloneMonthSymbol:
            return calendar.standaloneMonthSymbols[self.monthNumber! - 1]
        case .veryShortMonthSymbol:
            return calendar.veryShortMonthSymbols[self.monthNumber! - 1]
        case .shortStandaloneMonthSymbol:
            return calendar.shortStandaloneMonthSymbols[self.monthNumber! - 1]
        case .veryShortStandaloneMonthSymbol:
            return calendar.veryShortStandaloneMonthSymbols[self.monthNumber! - 1]
        }
    }
    
    enum MonthSymbolType {
        case monthSymbol
        case shortMonthSymbol
        case standaloneMonthSymbol
        case veryShortMonthSymbol
        case shortStandaloneMonthSymbol
        case veryShortStandaloneMonthSymbol
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

extension Date
{
    func isContained(fromDate: Date, toDate: Date) -> Bool
    {
        let range = fromDate...toDate
        
        return range.contains(self)
    }
}

extension Date
{
    func compare(with other: Date) -> DateComparisonResult {
        return DateComparisonResult(a: self, b: other)
    }
    
    struct DateComparisonResult {
        var a: Date
        var b: Date
        
        var older: Bool {
            a > b
        }
        
        var earliest: Date {
            if a > b {
                return a
            } else {
                return b
            }
        }
        
        var oldest: Date {
            if b > a {
                return b
            } else {
                return a
            }
        }
    }
}
