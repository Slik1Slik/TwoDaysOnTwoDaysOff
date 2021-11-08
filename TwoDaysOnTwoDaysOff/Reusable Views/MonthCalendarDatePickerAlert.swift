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
    
    @ObservedObject private var calendarManager: MonthCalendarManager = MonthCalendarManager()
    
    var body: some View {
        VStack {
            MonthView(calendarManager: calendarManager) { date in
                ItemView(date: date, calendarManager: calendarManager)
                    .disabled(!range.contains(date))
                    .foregroundColor(range.contains(date) ? .black : Color(.systemGray5))
            } header: { date in
                header(date: date)
                    .padding(.vertical, calendarManager.layoutConfiguration.paddingTop)
                    .padding(.horizontal, calendarManager.layoutConfiguration.paddingLeft)
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
        
        self.calendarManager = MonthCalendarManager(initialDate: selection.wrappedValue, calendar: DateConstants.calendar, layoutConfiguration: .alert)
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
                goToPreviousMonth()
            } label: {
                Image(systemName: "arrowtriangle.left.fill")
                    .renderingMode(.template)
                    .foregroundColor(isCurrentMonthFirst() ? Color(.systemGray5) : Color(.systemGray2))
            }
            .disabled(isCurrentMonthFirst())
            Spacer()
            Text(DateConstants.calendar.standaloneMonthSymbols[date.month! - 1].capitalized)
                .bold()
            Spacer()
            Button {
                goToNextMonth()
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
    private struct ItemView: DateViewProtocol {
        var date: Date
        @ObservedObject var monthCalendarManager: MonthCalendarManager
        
        var body: some View {
            Text(date.day!.description)
                .frame(width: monthCalendarManager.layoutConfiguration.item.width,
                       height: monthCalendarManager.layoutConfiguration.item.height)
                .background(backgroundColor)
                .clipShape(Circle())
                .onTapGesture(perform: selectDate)
        }
        
        init(date: Date, calendarManager: MonthCalendarManager) {
            self.date = date
            self.monthCalendarManager = calendarManager
        }
        
        private func selectDate() {
            self.monthCalendarManager.selectedDate = date
        }
        
        private var backgroundColor: Color {
            return date == monthCalendarManager.selectedDate ? Color(UserSettings.restDayCellColor!) : Color.clear
        }
    }
}

extension MonthCalendarDatePickerAlert {
    
    private func itemSize() -> CGFloat {
        guard calendarManager.calendarConfiguration.days().count == 42 else {
            return calendarManager.layoutConfiguration.item.height
        }
        var itemSize = calendarManager.layoutConfiguration.item.height
        itemSize -= itemSize / 6
        return itemSize
    }
    
    private func lineSpacing() -> CGFloat {
        guard calendarManager.calendarConfiguration.days().count == 42 else {
            return calendarManager.layoutConfiguration.lineSpacing
        }
        var lineSpacing = calendarManager.layoutConfiguration.lineSpacing
        
        lineSpacing -= lineSpacing / 5
        
        return lineSpacing
    }
}

extension MonthCalendarDatePickerAlert {
    private func goToNextMonth() {
        calendarManager.month = DateConstants.calendar.date(byAdding: .month, value: 1, to: calendarManager.month)!
    }
    private func goToPreviousMonth() {
        calendarManager.month = DateConstants.calendar.date(byAdding: .month, value: -1, to: calendarManager.month)!
    }
    private func isCurrentMonthFirst() -> Bool {
        return (calendarManager.month.month == range.lowerBound.month) && (calendarManager.month.year == range.lowerBound.year)
    }
    private func isCurrentMonthLast() -> Bool {
        return (calendarManager.month.month == range.upperBound.month) && (calendarManager.month.year == range.upperBound.year)
    }
}

extension MonthCalendarDatePickerAlert {
    
    private func cancelAction() {
        self.isPresented = false
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
