//
//  MonthView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthView<DateView: DateViewProtocol, Header: View>: View
{
    let month: Date
    var calendar: Calendar
    var dateViewType: DateView.Type
    
    var configuration = { (configuration: MonthCalendarConfiguration) in }
    private var _configuration: MonthCalendarConfiguration = MonthCalendarConfiguration()
    
    var header: (Date) -> Header = { date in
        HStack {
            Text(date.monthSymbolAndYear())
                .bold()
            Spacer()
        } as! Header
    }
    
    @State private var isPresented: Bool = false
    
    @Environment(\.locale) var locale
    
    var body: some View {
        VStack(spacing: _configuration.weekdaysRow.topInset) {
            header(month)
                .padding(.horizontal, _configuration.paddingRight)
            weeksSymbolsHeader
                .padding(.horizontal, _configuration.paddingRight)
            VStack(spacing: _configuration.lineSpacing) {
                ForEach(weeks(for: month), id: \.self) { week in
                    HStack(spacing: _configuration.interitemSpacing) {
                        ForEach(week, id: \.self) { day in
                            if calendar.isDate(day, equalTo: month, toGranularity: .month) {
                                dateViewType.init(date: day)
                            }
                            else {
                                dateViewType.init(date: day).hidden()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, _configuration.paddingRight)
        }
        .frame(width: _configuration.width)
        .padding(.top, _configuration.paddingTop)
        .padding(.bottom, _configuration.paddingBottom)
    }
    
    private func weeks(for month: Date) -> [[Date]] {
        let daysForMonth = days(for: month)
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
    
    private func days(for month: Date) -> [Date] {
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
    
    private var weeksSymbolsHeader: some View {
        let shortWeekdaySymbols = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        return HStack(spacing: _configuration.interitemSpacing) {
            ForEach(shortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .bold()
                    .foregroundColor(Color(.gray))
                    .frame(
                        width: _configuration.item.sideLength,
                        height: _configuration.item.sideLength,
                        alignment: .center
                    )
            }
        }
    }
    
    private var defaultHeader: (Date) -> Header = { date in
        HStack {
            Text(date.monthSymbolAndYear())
                .bold()
            Spacer()
        } as! Header
    }
}

extension MonthView {
    init(month: Date,
         calendar: Calendar,
         dateViewType: DateView.Type,
         configuration: @escaping (MonthCalendarConfiguration) -> (),
         header: @escaping (Date) -> Header
    ) {
        self.month = month
        self.calendar = calendar
        self.dateViewType = dateViewType
        self.configuration = configuration
        configuration(_configuration)
        self.header = header
    }
    
    init(month: Date,
         dateViewType: DateView.Type,
         configuration: @escaping (MonthCalendarConfiguration) -> ()
    ) {
        self.month = month
        self.dateViewType = dateViewType
        self.configuration = configuration
        configuration(_configuration)
        
        self.calendar = Calendar(identifier: .gregorian)
        self.calendar.locale = self.locale
    }
    
    init(month: Date,
         calendar: Calendar,
         dateViewType: DateView.Type,
         configuration: CalendarConfiguration,
         header: @escaping (Date) -> Header
    ) {
        self.month = month
        self.calendar = calendar
        self.dateViewType = dateViewType
        
        if configuration == .expanded {
            self._configuration = MonthCalendarConfiguration(width: UIScreen.main.bounds.width)
        } else {
            self._configuration = MonthCalendarConfiguration(width: UIScreen.main.bounds.width / 3)
        }
        
        self.header = header
    }
    
    init(month: Date,
         calendar: Calendar,
         dateViewType: DateView.Type,
         header: @escaping (Date) -> Header
    ) {
        self.init(month: month, calendar: calendar, dateViewType: dateViewType, configuration: .expanded, header: header)
    }
}

protocol DateViewProtocol: View {
    var date: Date { get set }
    init(date: Date)
}

extension MonthView {
    enum CalendarConfiguration {
        case expanded
        case alert
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(month: Date(), calendar: Calendar(identifier: .gregorian), dateViewType: DateView.self) { config in
            config.width = 400
        } header: { date in
            HStack {
                Text(date.monthSymbolAndYear())
                    .bold()
                Spacer()
            }
        }
    }
}
