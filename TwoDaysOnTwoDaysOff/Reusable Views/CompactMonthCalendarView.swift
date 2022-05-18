//
//  CompactMonthCalendarView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 29.09.2021.
//

import SwiftUI
import Combine
import UIKit

struct CompactMonthCalendarView: View {
    
    @Environment(\.colorPalette) private var colorPalette
    
    @ObservedObject var calendarManager: CalendarManager
    
    var onSelect: (Date) -> () = { _ in }
    
    var body: some View {
        VStack {
            MonthView(month: calendarManager.selectedMonth, calendarManager: calendarManager) { [calendarManager] date in
                ItemView(date: date, calendarManager: calendarManager)
            } header: { date in
                header(date: date)
            }
            .padding(.horizontal, calendarManager.layoutConfiguration.paddingLeft)
            .padding(.vertical, calendarManager.layoutConfiguration.paddingTop)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(colorPalette.backgroundPrimary)
        )
        .padding(.horizontal, LayoutConstants.perfectValueForCurrentDeviceScreen(16))
    }
    
    init(calendarManager: CalendarManager, onSelect: @escaping (Date) -> () = { _ in }) {
        self.calendarManager = calendarManager
        self.onSelect = onSelect
        
        let currentMonthDaysCount = calendarManager.calendar.generateDates(of: .month, for: calendarManager.selectedMonth).count
        let rowsCount = currentMonthDaysCount == 42 ? 6 : 5
        adjustContent(rowsCount: rowsCount)
    }
}

extension CompactMonthCalendarView {
    
    @ViewBuilder
    private func header(date: Date) -> some View {
        let isCurrentMonthFirst = isCurrentMonthFirst()
        let isCurrentMonthLast = isCurrentMonthLast()
        HStack {
            Button {
                changeMonth(to: .previous)
            } label: {
                Image(systemName: "arrowtriangle.left.fill")
                    .renderingMode(.template)
                    .foregroundColor(colorPalette.buttonTertiary)
            }
            .disabled(isCurrentMonthFirst)
            .opacity(isCurrentMonthFirst ? 0 : 1)
            Spacer()
            Text(DateConstants.monthSymbols[date.monthNumber! - 1])
                .bold()
            Spacer()
            Button {
                changeMonth(to: .next)
            } label: {
                Image(systemName: "arrowtriangle.right.fill")
                    .renderingMode(.template)
                    .foregroundColor(colorPalette.buttonTertiary)
            }
            .disabled(isCurrentMonthLast)
            .opacity(isCurrentMonthLast ? 0 : 1)
        }
    }
}

extension CompactMonthCalendarView {
    private struct ItemView: View {
        var date: Date
        @ObservedObject private var calendarManager = CalendarManager()
        
        @Environment(\.colorPalette) private var colorPalette
        
        var body: some View {
            Text(date.dayNumber!.description)
                .frame(width: calendarManager.layoutConfiguration.item.width, height: calendarManager.layoutConfiguration.item.height)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(Circle())
                .onTapGesture(perform: selectDate)
                .disabled(!calendarManager.interval.contains(date))
        }
        
        init(date: Date, calendarManager: CalendarManager) {
            self.date = date
            self.calendarManager = calendarManager
        }
        
        private func selectDate() {
            self.calendarManager.selectedDate = date
        }
        
        private var backgroundColor: Color {
            return calendarManager.calendar.isDate(date, inSameDayAs: calendarManager.selectedDate) ? colorPalette.buttonPrimary : Color.clear
        }
        
        private var foregroundColor: Color {
            let isInInterval = calendarManager.interval.contains(date)
            guard isInInterval else {
                return colorPalette.inactive
            }
            guard calendarManager.calendar.isDate(date, inSameDayAs: calendarManager.selectedDate) else {
                return .black
            }
            return colorPalette.buttonPrimary.isDark ? .white : .black
        }
    }
}

extension CompactMonthCalendarView {
    private func changeMonth(to state: MonthState) {
        let increment = state == .next ? 1 : -1
        
        let incomingMonth = calendarManager.calendar.date(byAdding: .month, value: increment, to: calendarManager.selectedMonth)!
        let incomingMonthDaysCount = calendarManager.calendar.generateDates(of: .month, for: incomingMonth).count
        
        calendarManager.selectedMonth = incomingMonth
        adjustContent(rowsCount: incomingMonthDaysCount == 42 ? 6 : 5)
    }
    private func isCurrentMonthFirst() -> Bool {
        return (calendarManager.selectedMonth.monthNumber == calendarManager.interval.start.monthNumber) && (calendarManager.selectedMonth.yearNumber == calendarManager.interval.start.yearNumber)
    }
    private func isCurrentMonthLast() -> Bool {
        return (calendarManager.selectedMonth.monthNumber == calendarManager.interval.end.monthNumber) && (calendarManager.selectedMonth.yearNumber == calendarManager.interval.end.yearNumber)
    }
    private func adjustContent(rowsCount: Int) {
        let initialLayoutConfiguration = CalendarLayoutConfiguration(width: UIScreen.main.bounds.width / 1.5)
        
        let defaultLineSpacing = initialLayoutConfiguration.calendarBody.lineSpacing
        let defaultCalendarBodyPaddingVertical = initialLayoutConfiguration.calendarBody.paddingTop
        let defaultItemSize = initialLayoutConfiguration.item.height
        
        let lineSpacingDifference = defaultItemSize / 6
        let paddingDifference = defaultLineSpacing / 2 + ((defaultItemSize / 6) / 2)
        
        let isCurrentLayoutMatchedWithDefault = calendarManager.layoutConfiguration.calendarBody.lineSpacing == defaultLineSpacing
        
        if rowsCount == 6 {
            if isCurrentLayoutMatchedWithDefault {
                calendarManager.layoutConfiguration.calendarBody.lineSpacing -= lineSpacingDifference
                calendarManager.layoutConfiguration.calendarBody.paddingTop -= paddingDifference
                calendarManager.layoutConfiguration.calendarBody.paddingBottom -= paddingDifference
            }
            
        } else {
            calendarManager.layoutConfiguration.calendarBody.lineSpacing = defaultLineSpacing
            calendarManager.layoutConfiguration.calendarBody.paddingTop = defaultCalendarBodyPaddingVertical
            calendarManager.layoutConfiguration.calendarBody.paddingBottom = defaultCalendarBodyPaddingVertical
        }
    }
    
    private enum MonthState {
        case next
        case previous
    }
}

struct CompactMonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CompactMonthCalendarView(calendarManager: CalendarManager())
    }
}
