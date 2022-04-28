//
//  Constants.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

struct DateConstants {
    static let calendar: Calendar = getCalendar()
    static let timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .current
    static let dateFormat = "dd-MM-yyyy"
    static let dateStyle: DateFormatter.Style = .short
    static let currentYear = Date().baseComponents().year
    static let dayInSeconds = 86400
    static let dateFormatter = getDateFormatter()
    static let date_01_01_1970 = getFirstDate()
    
    //due to the memory leak caused by using the Calendar.standaloneMonthSymbols array I've decided to store months symbols and provide it like this
    static let monthSymbols: Array<String> = getMonthSymbols()
    
    private static func getDateFormatter() -> DateFormatter
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter
    }
    
    private static func getFirstDate() -> Date
    {
        let formatter = getDateFormatter()
        
        return formatter.date(from: "01-01-1970")!
    }
    
    private static func getCalendar() -> Calendar
    {
        var calendar = Calendar(identifier: .gregorian)
        
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.timeZone = DateConstants.timeZone
        
        return calendar
    }
    
    private static func getMonthSymbols() -> [String] {
        return ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    }
}
