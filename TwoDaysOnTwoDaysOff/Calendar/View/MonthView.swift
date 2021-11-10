//
//  MonthView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthView<DateView: View, Header: View>: View
{
    private var layoutConfiguration = MonthCalendarLayoutConfiguration()
    @ObservedObject private var calendarConfiguration = MonthCalendarConfiguration()
    
    @ViewBuilder private var dateView: (Date) -> DateView
    
    @ViewBuilder private var header: (Date) -> Header
    
    var body: some View {
        VStack(spacing: layoutConfiguration.lineSpacing) { [calendarConfiguration, layoutConfiguration] in
            header(calendarConfiguration.month)
                .padding(.leading, layoutConfiguration.header.paddingLeft)
                .padding(.trailing, layoutConfiguration.header.paddingRight)
                .padding(.top, layoutConfiguration.header.paddingTop)
                .padding(.bottom, layoutConfiguration.header.paddingBottom)
                .frame(alignment: .top)
            VStack {
                weeksSymbolsHeader
                    .padding(.leading, layoutConfiguration.weekdaysRow.paddingLeft)
                    .padding(.trailing, layoutConfiguration.weekdaysRow.paddingRight)
                    .padding(.top, layoutConfiguration.weekdaysRow.paddingTop)
                    .padding(.bottom, layoutConfiguration.weekdaysRow.paddingBottom)
                VStack(spacing: layoutConfiguration.lineSpacing) { [self] in
                    ForEach(calendarConfiguration.weeks(), id: \.self) { week in
                        HStack(spacing: layoutConfiguration.interitemSpacing) { [self] in
                            ForEach(week, id: \.self) { day in
                                if calendarConfiguration.calendar.isDate(day, equalTo: calendarConfiguration.month, toGranularity: .month) {
                                    dateView(day)
                                        .frame(
                                            width: layoutConfiguration.item.width,
                                            height: layoutConfiguration.item.height
                                        )
                                }
                                else {
                                    Color.clear
                                        .frame(
                                            width: layoutConfiguration.item.width,
                                            height: layoutConfiguration.item.height
                                        )
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: layoutConfiguration.height, alignment: .top)
        }
        .frame(width: layoutConfiguration.width, alignment: .top)
    }
    
    init(month: Date,
         calendar: Calendar,
         layoutConfiguration: @escaping (MonthCalendarLayoutConfiguration) -> (),
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.calendarConfiguration = MonthCalendarConfiguration(calendar: calendar, month: month)
        
        self.dateView = dateView
        self.header = header
    }
}

extension MonthView where Header == HStack<TupleView<(Text, Spacer)>>, DateView == Text {
    init(month: Date,
         calendar: Calendar,
         calendarManager: MonthCalendarManager,
         @ViewBuilder layoutConfiguration: @escaping (MonthCalendarLayoutConfiguration) -> (),
         @ViewBuilder dateView: @escaping (Date) -> DateView
    ) {
        self.init(month: month, calendar: calendar, layoutConfiguration: layoutConfiguration, dateView: dateView) { date in
            HStack {
                Text(date.monthSymbolAndYear())
                Spacer()
            }
        }
    }
    
    init(month: Date,
         calendar: Calendar,
         calendarManager: MonthCalendarManager,
         @ViewBuilder layoutConfiguration: @escaping (MonthCalendarLayoutConfiguration) -> (),
         @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.init(month: month, calendar: calendar, layoutConfiguration: layoutConfiguration, dateView: { date in
            Text(date.day!.description)
        }, header: header)
    }
}

extension MonthView {
    init(calendarConfiguration: MonthCalendarConfiguration,
         layoutConfiguration: MonthCalendarLayoutConfiguration,
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.calendarConfiguration = calendarConfiguration
        self.layoutConfiguration = layoutConfiguration
        
        self.dateView = dateView
        self.header = header
    }
    
    init(month: Date,
         calendar: Calendar,
         layoutConfiguration: MonthCalendarLayoutConfiguration.LayoutConfiguration,
         @ViewBuilder dateView: @escaping (Date) -> DateView,
         @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.calendarConfiguration = MonthCalendarConfiguration(calendar: calendar, month: month)
        
        switch layoutConfiguration {
        case .expanded:
            self.layoutConfiguration = MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width)
        case .alert:
            self.layoutConfiguration = MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width / 1.2)
        }
        
        self.dateView = dateView
        self.header = header
    }
}

extension MonthView {
    private var weeksSymbolsHeader: some View {
        return HStack(spacing: layoutConfiguration.interitemSpacing) {
            ForEach(calendarConfiguration.weekdaySymbols(), id: \.self) { symbol in
                Text(symbol)
                    .bold()
                    .foregroundColor(Color(.gray))
                    .frame(
                        width: layoutConfiguration.item.width,
                        height: layoutConfiguration.item.width,
                        alignment: .center
                    )
            }
        }
    }
}

extension MonthView {
    enum ContentMode {
        case none
        case adjusted
        case fixed(rowsCount: Int)
    }
    
    func contentMode(_ mode: ContentMode) {
        
    }
    
    private func setAdjustedContentMode() {
        
    }
}

//struct MonthView_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthView(calendarManager: MonthCalendarManager())
//    }
//}
