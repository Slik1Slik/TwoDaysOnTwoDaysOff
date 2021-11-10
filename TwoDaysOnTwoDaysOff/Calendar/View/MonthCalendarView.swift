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
        
        let months = calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
        self.pages = months.map { month in
            return MonthPage(month: month)
        }
    }
    
    //private var layoutConfiguration = MonthCalendarLayoutConfiguration()
    
    var body: some View {
        ZStack {
            CalendarPager(selection: $index, pages: pages)
            getOnTopButton
        }
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    private var pages: [MonthPage]
    
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
    private var layoutConfiguration = MonthCalendarLayoutConfiguration()
    var body: some View {
        VStack {
            MonthView(month: id, calendar: DateConstants.calendar, layoutConfiguration: .expanded) { date in
                DateView(date: date)
            } header: { date in
                header(month: date)
            }
            MonthAccessoryView(month: id)
                .padding(.leading, 16)
                .padding(.trailing, 16)
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height)
    }
    init(month: Date) {
        self.id = month
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
