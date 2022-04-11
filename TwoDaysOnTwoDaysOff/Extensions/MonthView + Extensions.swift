//
//  MonthView + Extensions.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 15.03.2022.
//

import Foundation
import SwiftUI

extension MonthView where Header == DefaultHeader,
                          WeekdaysRow == DefaultWeekdaysRow,
                          DateView == DefaultDateView {
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         showsHeader: Bool = true,
         showsWeekdaysRow: Bool = true
    ) {
        self.init(month: month,
                  calendarManager: calendarManager,
                  dateView: { date in
            DefaultDateView(date: date, calendarManager: calendarManager)
        },
                  header: { date in
            DefaultHeader(date: date, calendarManager: calendarManager)
        },
                  weekdaysRow: {
            DefaultWeekdaysRow(calendarManager: calendarManager)
        })
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdaysRow
    }
}

extension MonthView where Header == DefaultHeader,
                          WeekdaysRow == DefaultWeekdaysRow {
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         showsHeader: Bool = true,
         showsWeekdaysRow: Bool = true,
         @ViewBuilder dateView: @escaping (Date) -> DateView
    ) {
        self.init(month: month,
                  calendarManager: calendarManager,
                  dateView: dateView,
                  header: { date in
            DefaultHeader(date: date, calendarManager: calendarManager)
        },
                  weekdaysRow: {
            DefaultWeekdaysRow(calendarManager: calendarManager)
        })
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdaysRow
    }
}

extension MonthView where DateView == DefaultDateView,
                          WeekdaysRow == DefaultWeekdaysRow {
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         showsHeader: Bool = true,
         showsWeekdaysRow: Bool = true,
         @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.init(month: month,
                  calendarManager: calendarManager,
                  dateView: { date in
            DefaultDateView(date: date, calendarManager: calendarManager)
        },
                  header: header,
                  weekdaysRow: {
            DefaultWeekdaysRow(calendarManager: calendarManager)
        })
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdaysRow
    }
}

extension MonthView where DateView == DefaultDateView,
                          Header == DefaultHeader {
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         showsHeader: Bool = true,
         showsWeekdaysRow: Bool = true,
         @ViewBuilder weekdaysRow: @escaping () -> WeekdaysRow
    ) {
        self.init(month: month, calendarManager: calendarManager, dateView: { date in
            DefaultDateView(date: date, calendarManager: calendarManager)
        },
                  header: { date in
            DefaultHeader(date: date, calendarManager: calendarManager)
        },
                  weekdaysRow: weekdaysRow)
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdaysRow
    }
}

extension MonthView where DateView == DefaultDateView {
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         showsHeader: Bool = true,
         showsWeekdaysRow: Bool = true,
         @ViewBuilder header: @escaping (Date) -> Header,
         @ViewBuilder weekdaysRow: @escaping () -> WeekdaysRow
    )
    {
        self.init(month: month, calendarManager: calendarManager, dateView: { date in
            DefaultDateView(date: date, calendarManager: calendarManager)
        },
                  header: header,
                  weekdaysRow: weekdaysRow)
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdaysRow
    }
}

extension MonthView where Header == DefaultHeader {
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         showsHeader: Bool = true,
         showsWeekdaysRow: Bool = true,
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder weekdaysRow: @escaping () -> WeekdaysRow
    )
    {
        self.init(month: month, calendarManager: calendarManager, dateView: dateView,
                  header: { date in
            DefaultHeader(date: date, calendarManager: calendarManager)
        },
                  weekdaysRow: weekdaysRow)
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdaysRow
    }
}
    
extension MonthView where WeekdaysRow == DefaultWeekdaysRow {
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         showsHeader: Bool = true,
         showsWeekdaysRow: Bool = true,
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder header: @escaping (Date) -> Header
    )
    {
        self.init(month: month,
                  calendarManager: calendarManager,
                  dateView: dateView,
                  header: header,
                  weekdaysRow: {
            DefaultWeekdaysRow(calendarManager: calendarManager)
        })
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdaysRow
    }
}



//MARK: Default placeholders if the views do not need to be specified
struct DefaultDateView: View {
    var date: Date
    var calendarManager: MonthCalendarManager
    
    var body: some View {
        Text(date.dayNumber!.description)
            .frame(
                width: calendarManager.layoutConfiguration.item.width,
                height: calendarManager.layoutConfiguration.item.height
            )
            .font(calendarManager.layoutConfiguration.calendarBody.font)
    }
}

struct DefaultHeader: View {
    var date: Date
    var calendarManager: MonthCalendarManager
    
    var body: some View {
        HStack {
            Text(date.monthSymbol(.monthSymbol) + " " + date.yearNumber!.description)
                .font(calendarManager.layoutConfiguration.header.font)
            Spacer()
        }
    }
}

struct DefaultWeekdaysRow: View {
    var calendarManager: MonthCalendarManager
    
    var body: some View {
        HStack(spacing: calendarManager.layoutConfiguration.calendarBody.interitemSpacing) {
            ForEach(MonthCalendarConfiguration().weekdaySymbols(), id: \.self) { symbol in
                Text(symbol)
                    .font(calendarManager.layoutConfiguration.weekdaysRow.font)
                    .foregroundColor(Color(.gray))
                    .frame(
                        width: calendarManager.layoutConfiguration.item.width,
                        height: calendarManager.layoutConfiguration.item.height,
                        alignment: .center
                    )
            }
        }
    }
}
