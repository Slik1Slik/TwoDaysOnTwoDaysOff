//
//  YearCalendarPage.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 26.04.2022.
//

import SwiftUI

struct YearCalendarView: View {
    
    @ObservedObject private var calendarManager: CalendarManager
    @ObservedObject private var viewModel: YearCalendarViewViewModel = YearCalendarViewViewModel()
    
    var onSelect: (Date) -> () = { _ in }
    
    @Environment(\.colorPalette) private var colorPalette: ColorPalette
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(calendarManager.years, id: \.self) { year in
                            yearPage(for: year)
                            .id(year.yearNumber!)
                        }
                        .padding(.top, LayoutConstants.safeFrame.minY)
                    }
                }
                .onAppear {
                    withAnimation {
                        proxy.scrollTo(calendarManager.selectedMonth.yearNumber, anchor: .top)
                    }
                }
            }
        }
        .ifAvailable.overlay(alignment: .top) {
            header
        }
    }
    
    private var header: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(stops: [
                .init(color: Color(UIColor.systemBackground), location: 0.35),
                .init(color: Color(UIColor.systemBackground).opacity(0.75), location: 0.4),
                .init(color: Color(UIColor.systemBackground).opacity(0.5), location: 0.5),
                .init(color: Color(UIColor.systemBackground).opacity(0.25), location: 0.6),
                .init(color: Color(UIColor.systemBackground).opacity(0.1), location: 0.65),
                .init(color: Color(UIColor.systemBackground).opacity(0.05), location: 0.7),
                .init(color: Color(UIColor.systemBackground).opacity(0.01), location: 0.8),
                .init(color: Color(UIColor.systemBackground).opacity(0.005), location: 0.9),
                .init(color: Color(UIColor.systemBackground).opacity(0.001), location: 1)
            ]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea(.all, edges: .top)
            .frame(height: LayoutConstants.safeFrame.minY + LayoutConstants.perfectValueForCurrentDeviceScreen(35))
    }
    
    @ViewBuilder
    private func monthView(month: Date) -> some View {
        let isMonthInInterval = viewModel.intervalContains(month: month) && calendarManager.calendar.lastDateOf(month: month)!.startOfDay >= Date().startOfDay
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
                calendarManager.selectedMonth = month
                onSelect(month)
            }
            .disabled(!isMonthInInterval)
    }
    
    @ViewBuilder
    private func yearPage(for year: Date) -> some View {
        let calendarConfiguration = YearCalendarConfiguration(calendar: calendarManager.calendar, year: year)
        VStack(spacing: LayoutConstants.perfectValueForCurrentDeviceScreen(5)) {
            yearLabel(year.yearNumber!.description)
                .padding(.horizontal, LayoutConstants.perfectValueForCurrentDeviceScreen(16))
            ForEach(calendarConfiguration.quarters, id: \.self) { quarter in
                HStack(spacing: LayoutConstants.perfectValueForCurrentDeviceScreen(4)) {
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
    
    private func yearLabel(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.largeTitle.bold())
            Spacer()
        }
    }
    
    init(calendarManager: CalendarManager, onSelect: @escaping (Date) -> () = { _ in }) {
        self.calendarManager = calendarManager
        
        self.calendarManager.layoutConfiguration.width = (UIScreen.main.bounds.width - (LayoutConstants.perfectValueForCurrentDeviceScreen(32))) / 3
        self.calendarManager.layoutConfiguration.calendarBody.paddingTop = 0
        self.calendarManager.layoutConfiguration.calendarBody.paddingBottom = 0
        
        self.onSelect = onSelect
    }
}

struct YearCalendarPage_Previews: PreviewProvider {
    static var previews: some View {
        YearCalendarView(calendarManager: CalendarManager())
    }
}
