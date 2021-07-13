//
//  MonthView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthView: View
{
    var calendar: Calendar
    let month: Date
    
    @State var isPresented: Bool = false
    
    init(month: Date) {
        self.month = month
        self.calendar = DateConstants.calendar
    }
    
    var body: some View {
        VStack(spacing: ExpandedMonthCalendarConstants.sectionInsets.bottom) {
            weeksSymbolsHeader
            VStack(spacing: ExpandedMonthCalendarConstants.minimumLineSpacing) {
                ForEach(weeks(for: month), id: \.self) { week in
                    HStack(spacing: ExpandedMonthCalendarConstants.minimumInteritemSpacing) {
                        ForEach(week, id: \.self) { day in
                            if calendar.isDate(day, equalTo: month, toGranularity: .month) {
                                DateView(date: day)
                            }
                            else {
                                DateView(date: day).hidden()
                            }
                        }
                    }
                }
            }
        }
        .frame(width: BasicCalendarConstants.maximumCalendarWidth)
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
        return HStack(spacing: ExpandedMonthCalendarConstants.minimumInteritemSpacing) {
            ForEach(shortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .bold()
                    .foregroundColor(Color(.gray))
                    .frame(
                        width: ExpandedMonthCalendarConstants.itemWidth,
                        height: ExpandedMonthCalendarConstants.itemWidth
                    )
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(month: Date())
    }
}
