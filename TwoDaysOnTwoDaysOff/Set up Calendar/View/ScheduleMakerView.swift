//
//  ScheduleMakerView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ScheduleMakerView: View {
    
    @ObservedObject private var userSettingsVM = UserSettingsViewModel()
    @ObservedObject private var calendarManager: CalendarManager
    
    @Environment(\.colorPalette) private var colorPalette
    
    @State private var currentIndex: Int = 0
    
    private var completion = {}
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectValueForCurrentDeviceScreen(35)) {
            HStack {
                if currentIndex != 0 {
                    Button {
                        withAnimation(.easeInOut) {
                            self.currentIndex -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorPalette.buttonPrimary)
                            .font(.title2)
                    }
                }
                Spacer()
                if (currentIndex != 1) {
                    Button("Далее") {
                        withAnimation(.easeInOut) {
                            currentIndex += 1
                        }
                    }
                    .font(.headline)
                    .foregroundColor(colorPalette.buttonPrimary)
                } else {
                    Button("Готово") {
                        self.userSettingsVM.saveUserSettings()
                        self.completion()
                    }
                    .font(.headline)
                    .foregroundColor(colorPalette.buttonPrimary)
                }
            }
            .padding(LayoutConstants.perfectValueForCurrentDeviceScreen(16))
            .transaction { transaction in
                transaction.animation = nil
            }
            if currentIndex == 0 {
                ScreenView(currentIndex: 0,
                           title: ScreenTitles.startDate.rawValue,
                           details: ScreenTitles.startDate.details) {
                    CompactMonthCalendarView(calendarManager: calendarManager)
                    
                }.transition(.scale)
            }
            
            if currentIndex == 1 {
                ScreenView(currentIndex: 1,
                           title: ScreenTitles.schedule.rawValue,
                           details: ScreenTitles.schedule.details) {
                    DaysCountPicker(workingDays: $userSettingsVM.countOfWorkingDays, restDays: $userSettingsVM.countOfRestDays)
                    
                }.transition(.scale)
            }
            Spacer()
        }
        .onChange(of: calendarManager.selectedDate) { newValue in
            userSettingsVM.startDate = newValue
        }
    }
    
    init() {
        let interval = DateInterval(start: Date().startOfDay, end: Date().addingTimeInterval(Double(DateConstants.dayInSeconds)*30.00))
        self.calendarManager = CalendarManager(calendar: DateConstants.calendar,
                                               interval: interval,
                                               initialDate: Date().startOfDay,
                                               layoutConfiguration: .alert)
    }
    
    public enum ScreenTitles: String
    {
        case startDate = "Когда у вас ближайшая смена?"
        case schedule = "Какой у вас график?"
        
        var details: String {
            switch self {
            case .startDate:
                return "Если у вас сегодня не выходной, необходимо выбрать первый рабочий день после предстоящих выходных. От этой даты будет рассчитан график."
            case .schedule:
                return "Ваш график, ничего сложного."
            }
        }
    }
}

struct ScheduleMakerView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleMakerView()
    }
}
