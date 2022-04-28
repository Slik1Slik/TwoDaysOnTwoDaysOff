//
//  CalendarView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.02.2022.
//

import SwiftUI
import UIKit

struct CalendarView: View {
    
    @State var index = 0
    
    @ObservedObject private var calendarManager: CalendarManager
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.calendarColorPalette) var calendarColorPalette
    
    @State private var calendarMode: CalendarMode = .month
    
    @State private var monthHeaderHeight: CGFloat = 0
    
    @State private var yearCalendarPageYPoint: CGFloat = 0
    @State private var yearCalendarPageHeight: CGFloat = 0
    
    var body: some View {
        NavigationView {
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
    }
    
    private var pages: [MonthCalendarPage] = []
    
    init(calendar: Calendar, interval: DateInterval) {
        self.calendarManager = CalendarManager(calendar: calendar,
                                                    interval: interval,
                                                    layoutConfiguration: .expanded)
        
        calendarManager.selectedDate = interval.start.compare(with: Date().startOfDay).oldest
        
        calendarManager.layoutConfiguration.item.height += MonthCalendarLayoutConstants.exceptionMarkCircleSize
        calendarManager.layoutConfiguration.calendarBody.lineSpacing = LayoutConstants.perfectPadding(8)
        calendarManager.layoutConfiguration.calendarBody.paddingTop += LayoutConstants.perfectPadding(8)
        
        pages = calendarManager.months.map { month in
            MonthCalendarPage(month: month, calendarManager: calendarManager)
        }
    }
    
    private var monthCalendarView: some View {
        VStack(spacing: 0) {
            CalendarPager(selection: $index, pages: pages)
                .onChange(of: index) { newValue in
                    withAnimation(.easeOut(duration: 0.3)) {
                        let month = calendarManager.months[newValue]
                        calendarManager.selectedMonth = month
                        if calendarManager.selectedYear != month {
                            calendarManager.selectedYear = month
                        }
                    }
                }
                .padding(.top, monthHeaderHeight)
            Divider()
                .animation(.linear)
            MonthAccessoryView(date: calendarManager.selectedDate)
                .animation(.linear)
                .environment(\.colorPalette, colorPalette)
        }
            .overlay(monthCalendarHeader, alignment: .top)
            .fixPushingUp()
            .background(colorPalette.backgroundPrimary)
    }
    
    private var calendarModeButton: some View {
        Button(action: {
            withAnimation {
                calendarMode.toggle()
            }
        }) {
            Text(calendarManager.selectedMonth.yearNumber!.description)
        }
        .foregroundColor(colorPalette.buttonPrimary)
        .font(.title.weight(.thin))
    }
    
    private var getToFirstMonthButton: some View {
        Button {
            withAnimation {
                index = 0
            }
        } label: {
            Image(systemName: "arrow.turn.up.left")
        }
        .foregroundColor(colorPalette.buttonSecondary)
        .font(.title.weight(.thin))
    }
    
    private var monthLabel: some View {
        Text(calendarManager.selectedMonth.monthSymbol(.standaloneMonthSymbol).capitalized)
            .font(.largeTitle)
            .bold()
    }
    
    private var weekdaysRow: some View {
        HStack(spacing: calendarManager.layoutConfiguration.calendarBody.interitemSpacing) {
            ForEach(MonthCalendarConfiguration().weekdaySymbols(), id: \.self) { symbol in
                Text(symbol)
                    .font(calendarManager.layoutConfiguration.weekdaysRow.font)
                    .foregroundColor(Color(.gray))
                    .frame(
                        width: calendarManager.layoutConfiguration.weekdaysRow.height,
                        alignment: .center
                    )
            }
        }
    }
    
    private var monthCalendarHeader: some View {
        VStack(spacing: 0) {
            VStack(spacing: LayoutConstants.perfectPadding(16)) {
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
                    .padding(.bottom, LayoutConstants.perfectPadding(8))
            }
            .padding(.horizontal, LayoutConstants.perfectPadding(16))
            Divider()
        }
        .background(colorPalette.backgroundPrimary.ignoresSafeArea(.container, edges: [.horizontal, .top]))
        .overlay(
            GeometryReader { proxy -> Color in
                if monthHeaderHeight == 0 {
                    monthHeaderHeight = proxy.frame(in: .global).height
                }
                return Color.clear
            },
            alignment: .top
        )
    }
}

extension CalendarView {
    
    @ViewBuilder
    private var yearCalendarView: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(calendarManager.years, id: \.self) { year in
                            YearCalendarPage(year: year, calendar: calendarManager.calendar) { selectedMonth in
                                index = calendarManager.months.firstIndex(where: { month in
                                    calendarManager.calendar.isDate(month, equalTo: selectedMonth, toGranularity: .month)
                                }) ?? 0
                                calendarManager.selectedMonth = selectedMonth
                                withAnimation {
                                    calendarMode = .month
                                }
                            }
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
        .overlay(yearCalendarHeader, alignment: .top)
    }
    
    private var yearCalendarHeader: some View {
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
            .frame(height: LayoutConstants.safeFrame.minY + LayoutConstants.perfectPadding(35))
    }
}

struct YearCalendarPageOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
