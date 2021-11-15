//
//  WheelDatePickerAlert.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 29.09.2021.
//

import SwiftUI
import Combine

struct MonthCalendarDatePickerAlert: View {
    @Binding private var isPresented: Bool
    @Binding private var selection: Date
    
    @State private var yPoint: CGFloat = UIScreen.main.bounds.height
    @State private var scaleEffect: CGFloat = 0
    @State private var opacity: Double = 1
    
    @ViewBuilder private var range: ClosedRange<Date>
    
    @ObservedObject private var calendarManager = MonthCalendarManager()
    
    var body: some View {
        VStack {
            MonthView(month: calendarManager.currentMonth, calendarManager: calendarManager) { [calendarManager] date in
                ItemView(date: date, calendarManager: calendarManager)
                    .disabled(!range.contains(date))
                    .foregroundColor(range.contains(date) ? .black : Color(.systemGray5))
            } header: { date in
                header(date: date)
            }
            .padding(.horizontal, calendarManager.layoutConfiguration.paddingLeft)
            .padding(.vertical, calendarManager.layoutConfiguration.paddingTop)
            controlBox()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(.white))
        )
        .scaleEffect(scaleEffect)
        .opacity(opacity)
        .offset(y: yPoint)
        .padding(.horizontal)
        .onChange(of: isPresented) { value in
            if value {
                self.show()
            } else {
                self.hide()
            }
        }
        .disabled(!isPresented)
    }
    
    init(selection: Binding<Date>, range: ClosedRange<Date>, isPresented: Binding<Bool>) {
        self._selection = selection
        self.range = range
        self._isPresented = isPresented
        
        self.calendarManager = MonthCalendarManager(calendar: DateConstants.calendar,
                                                    interval: DateInterval(start: range.lowerBound, end: range.upperBound),
                                                    currentMonth: selection.wrappedValue,
                                                    initialDate: selection.wrappedValue,
                                                    layoutConfiguration: .alert)
        
        self.calendarManager.layoutConfiguration.weekdaysRow.paddingTop = LayoutConstants.perfectPadding(10)
    }
    
    private func show() {
        let workItem = DispatchWorkItem {
            self.yPoint = 0
        }
        workItem.perform()
        workItem.notify(queue: DispatchQueue.main) {
            withAnimation(.easeOut) {
                self.scaleEffect = 1
            }
        }
        workItem.cancel()
    }
    
    private func hide() {
        let duration = 0.1
        withAnimation(.easeIn(duration: duration)){
            self.opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.scaleEffect = 0
            self.opacity = 1
            self.yPoint = UIScreen.main.bounds.height
        }
        self.isPresented = false
    }
}

extension MonthCalendarDatePickerAlert {
    private func header(date: Date) -> some View {
        HStack {
            Button {
                changeMonth(to: .previous)
            } label: {
                Image(systemName: "arrowtriangle.left.fill")
                    .renderingMode(.template)
                    .foregroundColor(isCurrentMonthFirst() ? Color(.systemGray5) : Color(.systemGray2))
            }
            .disabled(isCurrentMonthFirst())
            Spacer()
            Text(DateConstants.monthSymbols[date.month! - 1])
                .bold()
            Spacer()
            Button {
                changeMonth(to: .next)
            } label: {
                Image(systemName: "arrowtriangle.right.fill")
                    .renderingMode(.template)
                    .foregroundColor(isCurrentMonthLast() ? Color(.systemGray5) : Color(.systemGray2))
            }
            .disabled(isCurrentMonthLast())
        }
    }
}

extension MonthCalendarDatePickerAlert {
    private struct ItemView: View {
        var date: Date
        @ObservedObject private var calendarManager = MonthCalendarManager()
        
        var body: some View {
            Text(date.day!.description)
                .frame(width: calendarManager.layoutConfiguration.item.width, height: calendarManager.layoutConfiguration.item.height)
                .background(backgroundColor)
                .clipShape(Circle())
                .onTapGesture(perform: selectDate)
        }
        
        init(date: Date, calendarManager: MonthCalendarManager) {
            self.date = date
            self.calendarManager = calendarManager
        }
        
        private func selectDate() {
            self.calendarManager.selectedDate = date
        }
        
        private var backgroundColor: Color {
            return date == calendarManager.selectedDate ? Color(UserSettings.restDayCellColor!) : Color.clear
        }
    }
}

extension MonthCalendarDatePickerAlert {
    private func changeMonth(to state: MonthState) {
        let increment = state == .next ? 1 : -1
        
        let incomingMonth = calendarManager.calendar.date(byAdding: .month, value: increment, to: calendarManager.currentMonth)!
        let incomingMonthDaysCount = calendarManager.calendar.generateDates(of: .month, for: incomingMonth).count
        
        calendarManager.currentMonth = incomingMonth
        adjustContent(rowsCount: incomingMonthDaysCount == 42 ? 6 : 5)
    }
    private func isCurrentMonthFirst() -> Bool {
        return (calendarManager.currentMonth.month == range.lowerBound.month) && (calendarManager.currentMonth.year == range.lowerBound.year)
    }
    private func isCurrentMonthLast() -> Bool {
        return (calendarManager.currentMonth.month == range.upperBound.month) && (calendarManager.currentMonth.year == range.upperBound.year)
    }
    private func adjustContent(rowsCount: Int) {
        let initialLayoutConfiguration = MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width / 1.5)
        
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

extension MonthCalendarDatePickerAlert {
    
    private func cancelAction() {
        self.hide()
    }
    
    private func acceptAction() {
        self.selection = calendarManager.selectedDate!
        self.isPresented = false
    }
    
    private func controlBox() -> some View {
        HStack {
            Button {
                cancelAction()
            } label: {
                Text("Cancel")
                    .foregroundColor(Color(.systemGray3))
                    .bold()
            }
            Divider()
            Button {
                acceptAction()
            } label: {
                Text("Accept")
                    .foregroundColor(Color(UserSettings.restDayCellColor!))
                    .bold()
            }
        }
        .frame(height: calendarManager.layoutConfiguration.item.height)
    }
}

struct WheelDatePickerAlert_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarDatePickerAlert(selection: .constant(Date()), range: Date()...Date(), isPresented: .constant(true))
    }
}
