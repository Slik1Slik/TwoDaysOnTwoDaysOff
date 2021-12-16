//
//  DateView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct DateView: View {
    var date: Date
    @ObservedObject private var dayViewModel = DayViewModel()
    
    @State private var opacity: Double = 1
    
    @ObservedObject private var calendarManager: MonthCalendarManager = MonthCalendarManager()
    
    var body: some View {
        VStack(spacing: 2) {
            Text(String(date.day!))
                .font(.title3)
                .foregroundColor(textColor)
                .frame(width: MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width).item.width,
                       height: MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width).item.width)
                .background(backgroundColor)
                .clipShape(Circle())
                .opacity(isSelected || isSelectedAsExceptionForPeriod ? 0.3 : 1)
                .onAppear(perform: {
                    self.dayViewModel.date = date
                })
                .onTapGesture {
                    onTapGestureAction()
                }
            if let day = dayViewModel.day, let _ = day.exception  {
                Color(.gray)
                    .frame(width: 7, height: 7)
                    .clipShape(Circle())
            } else {
                Spacer()
            }
        }
        .disabled(isDisabled)
    }
    
    private var backgroundColor: Color {
        guard let day = dayViewModel.day else {
            return .clear
        }
        return day.isWorking ? Color(UserSettings.workingDayCellColor!) : Color(UserSettings.restDayCellColor!)
    }
    
    private var textColor: Color {
        guard let day = dayViewModel.day else {
            return Color(.lightGray)
        }
        return day.isWorking ? Color.black : Color.white
    }
    
    private var isDisabled: Bool {
        return dayViewModel.day == nil
    }
    
    private var isSelected: Bool {
        return date == calendarManager.selectedDate
    }
    
    private var isSelectedAsExceptionForPeriod: Bool {
        guard let _ = calendarManager.selectedDate,
              let day = dayViewModel.day,
              let exception = day.exception,
              !exception.isInvalidated,
              exception.from != exception.to else
        {
            return false
        }
        let exceptionPeriod = (exception.from...exception.to)
        return exceptionPeriod.contains(date) && exceptionPeriod.contains(calendarManager.selectedDate!)
    }
    
    private func onTapGestureAction() {
        guard !isSelected else {
            calendarManager.selectedDate = nil
            opacity = 1
            return
        }
        self.calendarManager.selectedDate = date
        opacity = 0.3
    }
    
    init(date: Date, calendarManager: MonthCalendarManager) {
        self.date = date
        self.dayViewModel.date = date
        self.calendarManager = calendarManager
    }
}

extension DateView {
    enum TapInfo {
        case active
        case inactive
        
        var isActive: Bool {
            switch self {
            case .active: return true
            case .inactive: return false
            }
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(date: Date(), calendarManager: MonthCalendarManager())
    }
}
