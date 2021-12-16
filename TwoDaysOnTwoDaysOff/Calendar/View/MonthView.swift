//
//  MonthView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthView<DateView: View, Header: View, AccessoryView: View>: View
{
    @ObservedObject private var calendarManager = MonthCalendarManager()
    
    private var calendarConfiguration: MonthCalendarConfiguration
    
    @ViewBuilder private var dateView: (Date) -> DateView
    
    @ViewBuilder private var header: (Date) -> Header
    
    @ViewBuilder private var accessoryView: () -> AccessoryView
    
    var body: some View {
        VStack {
            header(calendarConfiguration.month)
                .padding(.leading, calendarManager.layoutConfiguration.header.paddingLeft)
                .padding(.trailing, calendarManager.layoutConfiguration.header.paddingRight)
                .padding(.top, calendarManager.layoutConfiguration.header.paddingTop)
                .padding(.bottom, calendarManager.layoutConfiguration.header.paddingBottom)
                .frame(alignment: .top)
            VStack {
                weeksSymbolsHeader
                    .padding(.leading, calendarManager.layoutConfiguration.weekdaysRow.paddingLeft)
                    .padding(.trailing, calendarManager.layoutConfiguration.weekdaysRow.paddingRight)
                    .padding(.top, calendarManager.layoutConfiguration.weekdaysRow.paddingTop)
                    .padding(.bottom, calendarManager.layoutConfiguration.weekdaysRow.paddingBottom)
                    .frame(alignment: .top)
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
            accessoryView()
                .padding(.leading, calendarManager.layoutConfiguration.accessoryView.paddingLeft)
                .padding(.trailing, calendarManager.layoutConfiguration.accessoryView.paddingRight)
                .padding(.top, calendarManager.layoutConfiguration.accessoryView.paddingTop)
                .padding(.bottom, calendarManager.layoutConfiguration.accessoryView.paddingBottom)
                .frame(alignment: .bottom)
        }
        .frame(width: calendarManager.layoutConfiguration.width, alignment: .top)
    }
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder header: @escaping (Date) -> Header,
         @ViewBuilder accessoryView: @escaping () -> AccessoryView
    ) {
        self.calendarManager = calendarManager
        self.calendarConfiguration = calendarManager.calendarConfiguration(for: month)
        
        self.dateView = dateView
        self.header = header
        self.accessoryView = accessoryView
    }
}

extension MonthView where Header == HStack<TupleView<(Text, Spacer)>>,
                          DateView == Text,
                          AccessoryView == EmptyView {
    init(month: Date,
         calendarManager: MonthCalendarManager,
         @ViewBuilder dateView: @escaping (Date) -> DateView
    ) {
        self.init(month: month, calendarManager: calendarManager, dateView: dateView) { date in
            HStack {
                Text(date.monthSymbolAndYear())
                Spacer()
            }
        } accessoryView: {
            EmptyView()
        }

    }
    
    init(month: Date,
         calendarManager: MonthCalendarManager,
         @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.init(month: month, calendarManager: calendarManager, dateView: { date in
            Text(date.day!.description)
        }, header: header) {
            EmptyView()
        }
    }
}

extension MonthView where AccessoryView == EmptyView {
    init(month: Date,
         calendarManager: MonthCalendarManager,
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.init(month: month, calendarManager: calendarManager, dateView: dateView, header: header) {
            EmptyView()
        }
    }
}

extension MonthView {
    private var weeksSymbolsHeader: some View {
        return HStack(spacing: calendarManager.layoutConfiguration.calendarBody.interitemSpacing) {
            ForEach(calendarConfiguration.weekdaySymbols(), id: \.self) { symbol in
                Text(symbol)
                    .bold()
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



//struct MonthView_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthView(calendarManager: MonthCalendarManager())
//    }
//}
