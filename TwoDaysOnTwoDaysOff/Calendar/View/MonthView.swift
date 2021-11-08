//
//  MonthView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthView<DateView: DateViewProtocol, Header: View>: View
{
    var dateViewType: DateView.Type = DateView.self
    
    @ObservedObject private var calendarManager: MonthCalendarManager = MonthCalendarManager()
    
    @State private var showsHeader: Bool = true
    @State private var showsWeekdaysRow: Bool = true
    
    private var header: (Date) -> Header
    
    var body: some View {
        VStack(spacing: calendarManager.layoutConfiguration.lineSpacing) {
            if showsHeader {
                header(calendarManager.month)
                    .padding(.leading, calendarManager.layoutConfiguration.header.paddingLeft)
                    .padding(.trailing, calendarManager.layoutConfiguration.header.paddingRight)
                    .padding(.top, calendarManager.layoutConfiguration.header.paddingTop)
                    .padding(.bottom, calendarManager.layoutConfiguration.header.paddingBottom)
            }
            if showsWeekdaysRow {
                weeksSymbolsHeader
                    .padding(.leading, calendarManager.layoutConfiguration.weekdaysRow.paddingLeft)
                    .padding(.trailing, calendarManager.layoutConfiguration.weekdaysRow.paddingRight)
                    .padding(.top, calendarManager.layoutConfiguration.weekdaysRow.paddingTop)
                    .padding(.bottom, calendarManager.layoutConfiguration.weekdaysRow.paddingBottom)
            }
            VStack(spacing: calendarManager.layoutConfiguration.lineSpacing) {
                ForEach(calendarManager.calendarConfiguration.weeks(), id: \.self) { week in
                    HStack(spacing: calendarManager.layoutConfiguration.interitemSpacing) {
                        ForEach(week, id: \.self) { day in
                            if calendarManager.calendarConfiguration.calendar.isDate(day, equalTo: calendarManager.month, toGranularity: .month) {
                                dateViewType.init(date: day, calendarManager: calendarManager)
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
         dateViewType: DateView.Type,
         showsHeader: Bool = true,
         showsWeekdays: Bool = true,
         header: @escaping (Date) -> Header
    ) {
        self.calendarManager = calendarManager
        self.dateViewType = dateViewType
        
        self.showsHeader = showsHeader
        self.showsWeekdaysRow = showsWeekdays
        
        self.header = header
    }
}

extension MonthView where Header == HStack<TupleView<(Text, Spacer)>> {
    init(calendarManager: MonthCalendarManager,
         dateViewType: DateView.Type,
         showsHeader: Bool = true,
         showsWeekdays: Bool = true
    ) {
        self.init(calendarManager: calendarManager, dateViewType: dateViewType, showsHeader: showsHeader, showsWeekdays: showsWeekdays) { date in
            HStack {
                Text(date.monthSymbolAndYear())
                Spacer()
            }
        }
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
        MonthView(calendarManager: MonthCalendarManager(), dateViewType: DateView.self) { date in
            HStack {
                Text(date.monthSymbolAndYear())
                    .bold()
                Spacer()
            }
        }
    }
}
