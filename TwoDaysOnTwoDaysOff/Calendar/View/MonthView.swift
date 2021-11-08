//
//  MonthView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthView<DateView: View, Header: View>: View
{
    @ObservedObject private var calendarManager: MonthCalendarManager = MonthCalendarManager()
    
    private var dateView: (Date) -> DateView
    
    private var header: (Date) -> Header
    
    var body: some View {
        VStack(spacing: calendarManager.layoutConfiguration.lineSpacing) {
            header(calendarManager.month)
                .padding(.leading, calendarManager.layoutConfiguration.header.paddingLeft)
                .padding(.trailing, calendarManager.layoutConfiguration.header.paddingRight)
                .padding(.top, calendarManager.layoutConfiguration.header.paddingTop)
                .padding(.bottom, calendarManager.layoutConfiguration.header.paddingBottom)
            weeksSymbolsHeader
                .padding(.leading, calendarManager.layoutConfiguration.weekdaysRow.paddingLeft)
                .padding(.trailing, calendarManager.layoutConfiguration.weekdaysRow.paddingRight)
                .padding(.top, calendarManager.layoutConfiguration.weekdaysRow.paddingTop)
                .padding(.bottom, calendarManager.layoutConfiguration.weekdaysRow.paddingBottom)
            VStack(spacing: calendarManager.layoutConfiguration.lineSpacing) {
                ForEach(calendarManager.calendarConfiguration.weeks(), id: \.self) { week in
                    HStack(spacing: calendarManager.layoutConfiguration.interitemSpacing) {
                        ForEach(week, id: \.self) { day in
                            if calendarManager.calendarConfiguration.calendar.isDate(day, equalTo: calendarManager.month, toGranularity: .month) {
                                dateView(day)
                                    .frame(
                                        width: calendarManager.layoutConfiguration.item.width,
                                        height: calendarManager.layoutConfiguration.item.height
                                    )
                            }
                            else {
                                Color.clear
                                    .frame(
                                        width: calendarManager.layoutConfiguration.item.width,
                                        height: calendarManager.layoutConfiguration.item.height
                                    )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, calendarManager.layoutConfiguration.paddingRight)
        }
        .frame(width: calendarManager.layoutConfiguration.width)
        .padding(.top, calendarManager.layoutConfiguration.paddingTop)
        .padding(.bottom, calendarManager.layoutConfiguration.paddingBottom)
    }
    
    init(calendarManager: MonthCalendarManager,
         dateView: @escaping (Date) -> DateView,
         header: @escaping (Date) -> Header
    ) {
        self.calendarManager = calendarManager
        self.dateView = dateView
        
        self.header = header
    }
}

extension MonthView where Header == HStack<TupleView<(Text, Spacer)>>, DateView == Text {
    init(calendarManager: MonthCalendarManager,
         dateView: @escaping (Date) -> DateView
    ) {
        self.init(calendarManager: calendarManager, dateView: dateView) { date in
            HStack {
                Text(date.monthSymbolAndYear())
                Spacer()
            }
        }
    }
    
    init(calendarManager: MonthCalendarManager) {
        self.init(calendarManager: calendarManager) { date in
            Text(date.day!.description)
        } header: { date in
            HStack {
                Text(date.monthSymbolAndYear())
                Spacer()
            }
        }
    }
    
    init(calendarManager: MonthCalendarManager,
         header: @escaping (Date) -> Header
    ) {
        self.init(calendarManager: calendarManager, dateView: { date in
            Text(date.day!.description)
        }, header: header)
    }
}

extension MonthView {
    private var weeksSymbolsHeader: some View {
        return HStack(spacing: calendarManager.layoutConfiguration.interitemSpacing) {
            ForEach(calendarManager.calendarConfiguration.weekdaySymbols(), id: \.self) { symbol in
                Text(symbol)
                    .bold()
                    .foregroundColor(Color(.gray))
                    .frame(
                        width: calendarManager.layoutConfiguration.item.width,
                        height: calendarManager.layoutConfiguration.item.width,
                        alignment: .center
                    )
            }
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(calendarManager: MonthCalendarManager())
    }
}
