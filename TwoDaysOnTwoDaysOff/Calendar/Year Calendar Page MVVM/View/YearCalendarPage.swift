//
//  YearCalendarPage.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 26.04.2022.
//

import SwiftUI

struct YearCalendarPage: View {
    
    var onMonthSelect: (Date) -> () = { _ in }
    
    @ObservedObject private var calendarManager: CalendarManager
    @ObservedObject private var viewModel: YearCalendarPageViewModel = YearCalendarPageViewModel()
    
    @Environment(\.colorPalette) private var colorPalette: ColorPalette
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectPadding(10)) {
            header
                .padding(.horizontal, LayoutConstants.perfectPadding(16))
            page
        }
    }
    
    private var header: some View {
        HStack {
            Text(calendarManager.selectedYear.yearNumber!.description)
                .font(.largeTitle.bold())
            Spacer()
        }
    }
    
    private var page: some View {
        VStack(spacing: 0) {
            ForEach(calendarManager.quarters, id: \.self) { quarter in
                HStack(spacing: LayoutConstants.perfectPadding(4)) {
                    ForEach(quarter, id: \.self) { month in
                        VStack {
                            monthView(month: month)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func monthView(month: Date) -> some View {
        let isMonthInInterval = viewModel.intervalContains(month: month)
        MonthView(month: month, calendarManager: calendarManager, showsHeader: true, showsWeekdaysRow: false, dateView: { date in
            Text(date.dayNumber!.description)
                .font(.system(size: 9))
                .foregroundColor(isMonthInInterval ? (calendarManager.isDateCurrent(date) ? colorPalette.buttonPrimary : colorPalette.textPrimary) : colorPalette.inactive)
        }, header: { month in
            Text(month.monthSymbol(.standaloneMonthSymbol).capitalized)
                .font(.headline)
                .foregroundColor(isMonthInInterval ? (calendarManager.isMonthCurrent(month) ? colorPalette.buttonPrimary : colorPalette.textPrimary) : colorPalette.inactive)
                .frame(maxWidth: .infinity, alignment: .leading)
        })
            .onTapGesture {
                onMonthSelect(month)
            }
            .disabled(!viewModel.intervalContains(month: month))
    }
    
    init(year: Date, calendar: Calendar, onMonthSelect: @escaping (Date) -> ()) {
        self.calendarManager = CalendarManager(calendar: calendar, interval: .year(year), layoutConfiguration: { config in
            config.width = (UIScreen.main.bounds.width - (LayoutConstants.perfectPadding(32))) / 3
            config.calendarBody.paddingTop = 0
            config.calendarBody.paddingBottom = 0
        })
        
        calendarManager.selectedYear = year
        
        self.viewModel.year = year
        
        self.onMonthSelect = onMonthSelect
    }
}

//struct YearCalendarPage_Previews: PreviewProvider {
//    static var previews: some View {
//        YearCalendarPage()
//    }
//}

//            .overlay(
//                GeometryReader { proxy -> Color in
//                    if occupiedSpace == 0 {
//                        occupiedSpace = proxy.frame(in: .global).height + LayoutConstants.safeFrame.minY + (UIScreen.main.bounds.height - LayoutConstants.safeFrame.maxY)
//                    }
//                    return Color.clear
//                },
//                alignment: .top
//            )
