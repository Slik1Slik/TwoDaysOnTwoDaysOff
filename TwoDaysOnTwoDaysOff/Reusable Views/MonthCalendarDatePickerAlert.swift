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
    
    private var calendarLayoutConfiguration = MonthCalendarLayoutConfiguration()
    @ObservedObject private var calendarConfiguration = MonthCalendarConfiguration()
    
    var body: some View {
        VStack {
            MonthView(calendarConfiguration: calendarConfiguration,
                      layoutConfiguration: calendarLayoutConfiguration) { date in
                ItemView(date: date,
                         calendarConfiguration: calendarConfiguration,
                         layoutConfiguration: calendarLayoutConfiguration)
                    .disabled(!range.contains(date))
                    .foregroundColor(range.contains(date) ? .black : Color(.systemGray5))
            } header: { date in
                header(date: date)
            }
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
    }
    
    init(selection: Binding<Date>, range: ClosedRange<Date>, isPresented: Binding<Bool>) {
        self._selection = selection
        self.range = range
        self._isPresented = isPresented
        
        self.calendarLayoutConfiguration = MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width / 1.2)
        self.calendarLayoutConfiguration.header.paddingBottom = LayoutConstants.perfectPadding(10)
        self.calendarConfiguration = MonthCalendarConfiguration(calendar: DateConstants.calendar, month: selection.wrappedValue, initialDate: selection.wrappedValue)
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
        @ObservedObject private var calendarConfiguration = MonthCalendarConfiguration()
        private var layoutConfiguration = MonthCalendarLayoutConfiguration()
        
        var body: some View {
            Text(date.day!.description)
                .frame(width: layoutConfiguration.item.width, height: layoutConfiguration.item.height)
                .background(backgroundColor)
                .clipShape(Circle())
                .onTapGesture(perform: selectDate)
        }
        
        init(date: Date,
             calendarConfiguration: MonthCalendarConfiguration,
             layoutConfiguration: MonthCalendarLayoutConfiguration) {
            self.date = date
            self.calendarConfiguration = calendarConfiguration
            self.layoutConfiguration = layoutConfiguration
        }
        
        private func selectDate() {
            self.calendarConfiguration.selectedDate = date
        }
        
        private var backgroundColor: Color {
            return date == calendarConfiguration.selectedDate ? Color(UserSettings.restDayCellColor!) : Color.clear
        }
    }
}

extension MonthCalendarDatePickerAlert {
    
    private func itemSize() -> CGFloat {
        guard calendarConfiguration.days().count == 42 else {
            return calendarLayoutConfiguration.item.height
        }
        var itemSize = calendarLayoutConfiguration.item.height
        itemSize -= itemSize / 6
        return itemSize
    }
    
    private func lineSpacing() -> CGFloat {
        guard calendarConfiguration.days().count == 42 else {
            return calendarLayoutConfiguration.lineSpacing
        }
        var lineSpacing = calendarLayoutConfiguration.lineSpacing
        
        lineSpacing -= lineSpacing / 5
        
        return lineSpacing
    }
}

extension MonthCalendarDatePickerAlert {
    private func changeMonth(to state: MonthState) {
        let increment = state == .next ? 1 : -1
        
        let incomingMonth = calendarConfiguration.calendar.date(byAdding: .month, value: increment, to: calendarConfiguration.month)!
//        let incomingMonthDaysCount = calendarConfiguration.calendar.generateDates(of: .month, for: incomingMonth).count
//
//        if incomingMonthDaysCount == 42 && calendarConfiguration.days().count < 42 {
//            adjustContent(rowsCount: 6)
//        }
//        if incomingMonthDaysCount < 42 && calendarConfiguration.days().count == 42 {
//            adjustContent(rowsCount: 5)
//        }
        
        calendarConfiguration.month = incomingMonth
    }
    private func isCurrentMonthFirst() -> Bool {
        return (calendarConfiguration.month.month == range.lowerBound.month) && (calendarConfiguration.month.year == range.lowerBound.year)
    }
    private func isCurrentMonthLast() -> Bool {
        return (calendarConfiguration.month.month == range.upperBound.month) && (calendarConfiguration.month.year == range.upperBound.year)
    }
    private func adjustContent(rowsCount: Int) {
        let initialLayoutConfiguration = MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width / 1.2)
        
        let lineSpacingDifference = initialLayoutConfiguration.lineSpacing / 5
        let itemHeightDifference = initialLayoutConfiguration.item.height / 6
        
        calendarLayoutConfiguration.lineSpacing += (rowsCount == 6) ? -lineSpacingDifference : lineSpacingDifference
        calendarLayoutConfiguration.item.height += (rowsCount == 6) ? -itemHeightDifference : itemHeightDifference
    }
    
    private enum MonthState {
        case next
        case previous
    }
}

extension MonthCalendarDatePickerAlert {
    
    private func cancelAction() {
        self.isPresented = false
    }
    
    private func acceptAction() {
        self.selection = calendarConfiguration.selectedDate
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
        .frame(height: calendarLayoutConfiguration.item.height)
    }
}

struct WheelDatePickerAlert_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarDatePickerAlert(selection: .constant(Date()), range: Date()...Date(), isPresented: .constant(true))
    }
}
