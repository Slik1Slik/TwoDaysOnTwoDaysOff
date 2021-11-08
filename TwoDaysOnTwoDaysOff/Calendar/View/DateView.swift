//
//  DateView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct DateView: DateViewProtocol {
    
    var date: Date
    @ObservedObject private var dayViewModel = DayViewModel()
    
    private let itemHeight: CGFloat = ExpandedMonthCalendarConstants.itemWidth
    @State private var isSelected: Bool = false
    @State private var opacity: Double = 1
    
    var monthCalendarManager: MonthCalendarManager = MonthCalendarManager()
    
    var body: some View {
        VStack(spacing: 2) {
            Text(String(date.day!))
                .font(.title3)
                .foregroundColor(textColor)
                .frame(width: MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width).item.width,
                       height: MonthCalendarLayoutConfiguration(width: UIScreen.main.bounds.width).item.width)
                .background(backgroundColor)
                .clipShape(Circle())
                .opacity(opacity)
                .onAppear(perform: {
                    self.dayViewModel.date = date
                })
                .sheet(isPresented: $isSelected, content: {
                    ExceptionDetailsView(date: date)
                })
                .onTapGesture {
                    self.isSelected = true
                    self.onTapGestureAction()
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
    
    private func onTapGestureAction() {
        self.opacity = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.opacity = 1
        }
    }
    
    init(date: Date, calendarManager: MonthCalendarManager) {
        self.date = date
        self.dayViewModel.date = date
        self.monthCalendarManager = calendarManager
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
