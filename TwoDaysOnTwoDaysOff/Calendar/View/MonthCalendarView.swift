//
//  MonthCalendarView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthCalendarView: View {
    
    var calendar: Calendar
    @State var index = 0
    let interval: DateInterval
    
    init(interval: DateInterval) {
        self.interval = interval
        self.calendar = DateConstants.calendar
    }
    
    var body: some View {
        ZStack {
            CalendarPager(selection: $index, pages: self.months.map { month in
                return MonthPage(month: month)
            })
            getOnTopButton
        }
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
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
    var body: some View {
        VStack {
            MonthHeader(month: id)
                .padding(.bottom, 5)
                .padding(.top, 16)
            MonthView(month: id, calendar: DateConstants.calendar, dateViewType: DateView.self)
                .padding(.bottom, 16)
            MonthAccessoryView(month: id)
                .padding(.leading, 16)
                .padding(.trailing, 16)
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height)
        //.padding()
    }
    init(month: Date) {
        self.id = month
    }
    
}

struct MonthHeader: View {
    private let calendar = DateConstants.calendar
    private let month: Date
    private let monthSymbol: String
    private let yearNumber: Int
    
    var body: some View {
        HStack {
            Text(monthSymbol)
                .font(.title)
                .bold()
            Text(String(yearNumber))
                .font(.title)
                .foregroundColor(Color(UserSettings.restDayCellColor!))
                .bold()
            Spacer()
        }
        .frame(width: BasicCalendarConstants.maximumCalendarWidth)
    }
    
    init(month: Date) {
        self.month = month
        
        let monthNumber = calendar.component(.month, from: month)-1
        
        self.monthSymbol = calendar.standaloneMonthSymbols[monthNumber].capitalized
        self.yearNumber = calendar.component(.year, from: month)
    }
}

struct MonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView(interval: DateInterval())
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
