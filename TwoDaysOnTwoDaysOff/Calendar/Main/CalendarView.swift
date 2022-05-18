//
//  CalendarView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.02.2022.
//

import SwiftUI

struct CalendarView: View {
    
    @State var index = 0
    
    @ObservedObject private var monthCalendarManager: CalendarManager = CalendarManager()
    @ObservedObject private var yearCalendarManager: CalendarManager = CalendarManager()
    
    @Environment(\.colorPalette) private var colorPalette
    
    @State private var calendarMode: CalendarMode = .month
    
    @State private var monthHeaderHeight: CGFloat = 0
    
    @State private var accessoryViewAnimation: Animation? = .none
    
    var body: some View {
        ZStack {
            if calendarMode == .month {
                monthCalendarView
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                yearCalendarView
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private var pages: [MonthCalendarPage] = []
    
    init(calendar: Calendar, interval: DateInterval) {
        self.monthCalendarManager = CalendarManager(calendar: calendar,
                                                    interval: interval,
                                                    layoutConfiguration: .expanded)
        
        let firstAvailableDateInIntreval = interval.start.compare(with: Date().startOfDay).oldest
        
        let yearCalendarIntervalStart = calendar.dateInterval(of: .year, for: Date())?.start ?? firstAvailableDateInIntreval
        let yearCalendarIntervalEnd = calendar.generateDates(of: .year, for: calendar.date(byAdding: .year, value: 1, to: yearCalendarIntervalStart)!).last ?? UserSettings.finalDate
        
        monthCalendarManager.selectedDate = firstAvailableDateInIntreval
        
        monthCalendarManager.layoutConfiguration.item.height += MonthCalendarLayoutConstants.exceptionMarkCircleSize
        monthCalendarManager.layoutConfiguration.calendarBody.lineSpacing = LayoutConstants.perfectValueForCurrentDeviceScreen(8)
        monthCalendarManager.layoutConfiguration.calendarBody.paddingTop += LayoutConstants.perfectValueForCurrentDeviceScreen(8)
        
        self.yearCalendarManager = CalendarManager(calendar: calendar,
                                                   interval: DateInterval(start: yearCalendarIntervalStart, end: yearCalendarIntervalEnd),
                                                   layoutConfiguration: .expanded)
        
        self.pages = monthCalendarManager.months.map { month in
            MonthCalendarPage(month: month, calendarManager: monthCalendarManager)
        }
    }
}

extension CalendarView {
    private var monthCalendarView: some View {
        VStack(spacing: 0) {
            CalendarPager(selection: $index, pages: pages)
                .onChange(of: index) { newValue in
                    let month = monthCalendarManager.months[newValue]
                    monthCalendarManager.selectedMonth = month
                    if monthCalendarManager.selectedYear != month {
                        monthCalendarManager.selectedYear = month
                    }
                }
                .padding(.top, monthHeaderHeight)
                .simultaneousGesture(
                    gestureToDisableAccessoryViewAnimationAfterAppearing
                )
            VStack(spacing: 0) {
                Divider()
                MonthAccessoryView(date: monthCalendarManager.selectedDate)
                    .environment(\.colorPalette, colorPalette)
            }
            .animation(accessoryViewAnimation)
        }
        .ifAvailable.overlay(alignment: .top, overlayContent: {
            monthCalendarHeader
        })
        .fixPushingUp()
        .background(colorPalette.backgroundPrimary)
        .simultaneousGesture(
            gestureToAbleAccessoryViewAnimationAfterAppearing
        )
    }
    
    private var calendarModeButton: some View {
        Button(action: {
            yearCalendarManager.selectedMonth = monthCalendarManager.selectedMonth
            if accessoryViewAnimation == .none {
                accessoryViewAnimation = .default
            }
            withAnimation {
                calendarMode.toggle()
            }
        }) {
            Text(monthCalendarManager.selectedMonth.yearNumber!.description)
        }
        .foregroundColor(colorPalette.buttonPrimary)
        .font(.title.weight(.thin))
    }
    
    private var getToFirstMonthButton: some View {
        Button {
            if accessoryViewAnimation == .none {
                accessoryViewAnimation = .default
            }
            withAnimation(.default) {
                index = 0
            }
        } label: {
            Image(systemName: "arrow.turn.up.left")
        }
        .foregroundColor(colorPalette.buttonSecondary)
        .font(.title.weight(.thin))
    }
    
    private var monthLabel: some View {
        Text(monthCalendarManager.selectedMonth.monthSymbol(.standaloneMonthSymbol).capitalized)
            .font(.largeTitle)
            .bold()
    }
    
    private var weekdaysRow: some View {
        HStack(spacing: monthCalendarManager.layoutConfiguration.calendarBody.interitemSpacing) {
            ForEach(MonthCalendarConfiguration().weekdaySymbols(), id: \.self) { symbol in
                Text(symbol)
                    .font(monthCalendarManager.layoutConfiguration.weekdaysRow.font)
                    .foregroundColor(colorPalette.textSecondary)
                    .frame(
                        width: monthCalendarManager.layoutConfiguration.weekdaysRow.height,
                        alignment: .center
                    )
            }
        }
    }
    
    private var monthCalendarHeader: some View {
        VStack(spacing: 0) {
            VStack(spacing: LayoutConstants.perfectValueForCurrentDeviceScreen(16)) {
                HStack {
                    monthLabel
                    Spacer()
                    calendarModeButton
                    if index != 0 {
                        withAnimation(.easeOut(duration: 0.1)) {
                            getToFirstMonthButton
                        }
                    }
                }
                weekdaysRow
                    .padding(.bottom, LayoutConstants.perfectValueForCurrentDeviceScreen(8))
            }
            .padding(.horizontal, LayoutConstants.perfectValueForCurrentDeviceScreen(16))
            Divider()
        }
        .background(colorPalette.backgroundPrimary.ignoresSafeArea(.container, edges: [.horizontal, .top]))
        .ifAvailable.overlay(alignment: .top) {
            GeometryReader { proxy -> Color in
                if monthHeaderHeight == 0 {
                    monthHeaderHeight = proxy.frame(in: .global).height
                }
                return Color.clear
            }
        }
    }
}

extension CalendarView {
    
    @ViewBuilder
    private var yearCalendarView: some View {
        YearCalendarView(calendarManager: yearCalendarManager, onSelect: { selectedMonth in
            monthCalendarManager.selectedMonth = selectedMonth
            index = monthCalendarManager.months.firstIndex(where: { month in
                monthCalendarManager.calendar.isDate(month, equalTo: selectedMonth, toGranularity: .month)
            }) ?? 0
            withAnimation {
                calendarMode.toggle()
            }
        })
    }
}

extension CalendarView {
    private var gestureToAbleAccessoryViewAnimationAfterAppearing: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { _ in
                if accessoryViewAnimation == .none {
                    accessoryViewAnimation = .default
                }
            }
    }
    private var gestureToDisableAccessoryViewAnimationAfterAppearing: some Gesture {
        TapGesture()
            .onEnded {
                if accessoryViewAnimation != .none {
                    accessoryViewAnimation = .none
                }
            }
    }
}
