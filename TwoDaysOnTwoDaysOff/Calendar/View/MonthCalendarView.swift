//
//  MonthCalendarView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthCalendarView: View {
    
    @State var index = 0
    
    @ObservedObject private var calendarManager: MonthCalendarManager
    
    @State private var isPageChanging = false
    
    @State private var isSidebarPresented = false
    
    @State private var swipeType: SwipeType = .short
    
    var body: some View {
        ZStack {
            Group {
                CalendarPagerView(selection: $index, pages: pages)
                VStack {
                    submenuButton
                        .padding(.top, LayoutConstants.safeFrame.minY)
                        .padding(.horizontal, LayoutConstants.perfectPadding(16))
                    calendarControlBox
                        .padding(.top, LayoutConstants.perfectPadding(16))
                        .padding(.horizontal, LayoutConstants.perfectPadding(18))
                    Spacer()
                    if let date = calendarManager.selectedDate {
                        MonthAccessoryView(date: date)
                            .padding(.bottom, (LayoutConstants.window.frame.maxY - LayoutConstants.safeFrame.maxY) + LayoutConstants.perfectPadding(16))
                            .padding(.top, LayoutConstants.perfectPadding(16))
                            .padding(.horizontal, LayoutConstants.perfectPadding(16))
                            .frame(width: calendarManager.layoutConfiguration.width,
                                   height: UIScreen.main.bounds.height - calendarManager.layoutConfiguration.height - LayoutConstants.safeFrame.minY - LayoutConstants.perfectPadding(34))
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
        .sidebar(isBarPresented: $isSidebarPresented, type: .regular) {
            Sidebar()
        }
    }
    
    private var pages: [MonthPage] = []
    
    init(calendar: Calendar, interval: DateInterval) {
        self.calendarManager = MonthCalendarManager(calendar: calendar,
                                                    interval: interval,
                                                    layoutConfiguration: .expanded)
        self.pages = calendarManager.months.map { month in
            return MonthPage(month: month, calendarManager: calendarManager)
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
                    .foregroundColor(Color(.label))
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
                .foregroundColor(Color(.label))
                .font(.title.weight(.thin))
        }
        .hidden(index == 0)
    }
    
    private var calendarModeButton: some View {
        Button {
            
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(Color(.label))
                .font(.title2.weight(.light))
        }
        
    }
    
    private var calendarControlBox: some View {
        HStack {
            Spacer()
            getToFirstMonth
        }
    }
}

struct MonthPage: View, Identifiable {
    var id: Date
    private var calendarManager: MonthCalendarManager
    
    var body: some View {
        VStack {
            MonthView(month: id, calendarManager: calendarManager) { date in
                DateView(date: date, calendarManager: calendarManager)
            } header: { date in
                header(month: date)
            } accessoryView: {
                
            }
            .padding(.horizontal, calendarManager.layoutConfiguration.paddingLeft)
            .padding(.top, LayoutConstants.safeFrame.minY + LayoutConstants.perfectPadding(34))
            .padding(.bottom, (LayoutConstants.window.frame.maxY - LayoutConstants.safeFrame.maxY))
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height)
    }
    init(month: Date, calendarManager: MonthCalendarManager) {
        self.id = month
        self.calendarManager = calendarManager
    }
    
    private func header(month: Date) -> some View {
        
        let monthSymbol = DateConstants.monthSymbols[month.month! - 1]
        let yearNumber = month.year!
        
        return HStack {
            Text(monthSymbol)
                .font(.title)
                .bold()
            Text(String(yearNumber))
                .font(.title)
                .foregroundColor(Color(UserSettings.restDayCellColor!))
                .bold()
            Spacer()
        }
    }
}

//struct MonthCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthCalendarView(calendar: DateConstants.calendar, interval: DateInterval())
//    }
//}
