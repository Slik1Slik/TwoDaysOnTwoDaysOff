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
    
    //private var layoutConfiguration = MonthCalendarLayoutConfiguration()
    
    var body: some View {
        ZStack {
            CalendarPager(selection: $index, pages: pages)
            getOnTopButton
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
    
    private var getOnTopButton: some View {
        return Group {
            VStack {
                HStack {
                    Spacer()
                    GetOnTopButton {
                        withAnimation {
                            index = 0
                        }
                    }
                }
                .padding(BasicCalendarConstants.paddingRight+3)
                Spacer()
            }
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
            .transition(.opacity)
            .hidden(index == 0)
        }
    }
}

struct MonthPage: View, Identifiable {
    var id: Date
    private var calendarManager: MonthCalendarManager
    var body: some View {
        VStack {
            MonthView(month: id, calendarManager: calendarManager) { date in
                DateView(date: date)
            } header: { date in
                header(month: date)
            }
            .padding(.horizontal, calendarManager.layoutConfiguration.paddingLeft)
            .padding(.vertical, calendarManager.layoutConfiguration.paddingTop)
            MonthAccessoryView(month: id)
                .padding(.leading, 16)
                .padding(.trailing, 16)
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

struct MonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView(calendar: DateConstants.calendar, interval: DateInterval())
    }
}

struct GetOnTopButton: View {
    var completion: ()->()
    var body: some View {
        Button {
            completion()
        } label: {
            Image(systemName: "arrow.turn.up.left")
                .font(.title2.weight(.light))
                .foregroundColor(Color(.label))
        }
    }
}
