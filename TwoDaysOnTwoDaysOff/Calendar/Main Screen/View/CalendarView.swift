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
    
    @ObservedObject private var calendarManager: MonthCalendarManager
    
    @State private var isSidebarPresented = false
    
    @Environment(\.colorPalette) private var colorPalette
    //@Environment(\.monthCalendarColorPalette) var monthCalendarColorPalette
    
    @State private var isMonthScale = true
    @State private var headerHeight: CGFloat = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CalendarPager(selection: $index, pages: pages)
                    .onChange(of: index) { newValue in
                        withAnimation(.easeOut(duration: 0.3)) {
                            calendarManager.currentMonth = calendarManager.months[newValue]
                        }
                    }
                    .padding(.top, headerHeight)
                    .scaleEffect(isMonthScale ? 1 : 0.3)
                //Spacer()
                Divider()
                    .animation(.linear)
                MonthAccessoryView(date: calendarManager.selectedDate)
                    .animation(.linear)
                    .environment(\.colorPalette, colorPalette)
            }
                .overlay(header, alignment: .top)
                .background(colorPalette.backgroundDefault)
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var pages: [MonthCalendarPage] = []
    
    init(calendar: Calendar, interval: DateInterval) {
        self.calendarManager = MonthCalendarManager(calendar: calendar,
                                                    interval: interval,
                                                    layoutConfiguration: .expanded)
        
        calendarManager.selectedDate = interval.start.compare(with: Date().short).oldest
        
        calendarManager.layoutConfiguration.item.height += MonthCalendarLayoutConstants.exceptionMarkCircleSize
        calendarManager.layoutConfiguration.calendarBody.lineSpacing = LayoutConstants.perfectPadding(8)
        calendarManager.layoutConfiguration.calendarBody.paddingTop += LayoutConstants.perfectPadding(8)
        
        pages = calendarManager.months.map { month in
            MonthCalendarPage(month: month, calendarManager: calendarManager)
        }
    }
    
    private var submenuButton: some View {
        HStack {
            Button {
                withAnimation {
                    isSidebarPresented = true
                }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.primary)
                    .font(.title.weight(.thin))
            }
            Spacer()
        }
    }
    
    private var getToFirstMonth: some View {
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
    
    private var calendarModeButton: some View {
        Button(action: {
            withAnimation {
                isMonthScale.toggle()
            }
        }) {
            Text(calendarManager.currentMonth.yearNumber!.description)
        }
        .foregroundColor(colorPalette.buttonPrimary)
        .font(.title.weight(.thin))
        
    }
    
    private var monthLabel: some View {
        Text(calendarManager.currentMonth.monthSymbol(.standaloneMonthSymbol).capitalized)
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
    
    private var header: some View {
        VStack(spacing: 0) {
            VStack(spacing: LayoutConstants.perfectPadding(16)) {
                HStack {
                    monthLabel
                    Spacer()
                    calendarModeButton
                    if index != 0 {
                        withAnimation(.easeOut(duration: 0.1)) {
                            getToFirstMonth
                        }
                    }
                }
                weekdaysRow
                    .padding(.bottom, LayoutConstants.perfectPadding(8))
            }
            //.padding(.top, LayoutConstants.safeFrame.minY + LayoutConstants.perfectPadding(8))
            .padding(.horizontal, LayoutConstants.perfectPadding(16))
            .background(Color.white.ignoresSafeArea(.container, edges: [.horizontal, .top]))
            Divider()
        }
//        .background(Rectangle().shadow(color: .gray, radius: 0.3, x: 1, y: 0))
//        .ignoresSafeArea(.all, edges: [.horizontal, .top])
        .overlay(
            GeometryReader { proxy -> Color in
                if headerHeight == 0 {
                    headerHeight = proxy.frame(in: .global).height
                }
                return Color.clear
            },
            alignment: .top
        )
    }
    
    private func getHeaderHeight() -> CGFloat {
        let headerTextHeight: CGFloat = 41
        let weekdaysRowHeight: CGFloat = 17
        let spacing = LayoutConstants.perfectPadding(16)
        let headerPaddingTop = LayoutConstants.perfectPadding(16)
        //let headerPaddingBottom = LayoutConstants.perfectPadding(8)
        //let calendarBodyPaddingTop = calendarManager.layoutConfiguration.calendarBody.paddingTop
        
        return headerTextHeight + spacing + headerPaddingTop + weekdaysRowHeight
    }
}
