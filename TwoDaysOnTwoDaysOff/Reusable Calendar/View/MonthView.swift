//
//  MonthView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthView<DateView: View, Header: View, WeekdaysRow: View>: View
{
    @ObservedObject private var calendarManager = CalendarManager()
    
    private var calendarConfiguration: MonthCalendarConfiguration
    
    @ViewBuilder private var dateView: (Date) -> DateView
    
    @ViewBuilder private var header: (Date) -> Header
    
    @ViewBuilder private var weekdaysRow: () -> WeekdaysRow
    
    var showsHeader: Bool = true
    var showsWeekdaysRow: Bool = true
    
    var body: some View {
        VStack {
            if showsHeader {
                header(calendarConfiguration.month)
                    .padding(.leading, calendarManager.layoutConfiguration.header.paddingLeft)
                    .padding(.trailing, calendarManager.layoutConfiguration.header.paddingRight)
                    .padding(.top, calendarManager.layoutConfiguration.header.paddingTop)
                    .padding(.bottom, calendarManager.layoutConfiguration.header.paddingBottom)
                    .frame(alignment: .top)
            }
            VStack {
                if showsWeekdaysRow {
                    weekdaysRow()
                        .padding(.leading, calendarManager.layoutConfiguration.weekdaysRow.paddingLeft)
                        .padding(.trailing, calendarManager.layoutConfiguration.weekdaysRow.paddingRight)
                        .padding(.top, calendarManager.layoutConfiguration.weekdaysRow.paddingTop)
                        .padding(.bottom, calendarManager.layoutConfiguration.weekdaysRow.paddingBottom)
                        .frame(alignment: .top)
                }
                VStack(spacing: calendarManager.layoutConfiguration.calendarBody.lineSpacing) { [self] in
                    ForEach(calendarConfiguration.weeks(), id: \.self) { week in
                        HStack(spacing: calendarManager.layoutConfiguration.calendarBody.interitemSpacing) { [self] in
                            ForEach(week, id: \.self) { day in
                                if calendarConfiguration.calendar.isDate(day, equalTo: calendarConfiguration.month, toGranularity: .month) {
                                    dateView(day)
                                        .frame(
                                            width: calendarManager.layoutConfiguration.item.width,
                                            height: calendarManager.layoutConfiguration.item.height
                                        )
                                }
                                else {
                                    dateView(day)
                                        .frame(
                                            width: calendarManager.layoutConfiguration.item.width,
                                            height: calendarManager.layoutConfiguration.item.height
                                        )
                                        .hidden()
                                }
                            }
                        }
                    }
                }
                .padding(.leading, calendarManager.layoutConfiguration.calendarBody.paddingLeft)
                .padding(.trailing, calendarManager.layoutConfiguration.calendarBody.paddingRight)
                .padding(.top, calendarManager.layoutConfiguration.calendarBody.paddingTop)
                .padding(.bottom, calendarManager.layoutConfiguration.calendarBody.paddingBottom)
                //.frame(height: calendarManager.layoutConfiguration.calendarBody.height, alignment: .top)
                //.overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.4))
            }
        }
        .frame(width: calendarManager.layoutConfiguration.width)
    }
    
    init(month: Date,
         calendarManager: CalendarManager,
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder header: @escaping (Date) -> Header,
         @ViewBuilder weekdaysRow: @escaping () -> WeekdaysRow
    ) {
        self.calendarManager = calendarManager
        self.calendarConfiguration = calendarManager.calendarConfiguration(for: month)
        
        self.dateView = dateView
        self.header = header
        self.weekdaysRow = weekdaysRow
    }
}

//struct MonthView_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthView(calendarManager: MonthCalendarManager())
//    }
//}
