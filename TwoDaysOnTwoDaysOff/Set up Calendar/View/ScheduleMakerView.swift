//
//  ScheduleMakerView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ScheduleMakerView: View {
    @ObservedObject private var userSettingsVM = UserSettingsViewModel()
    @State private var currentIndex: Int = 0
    private var completion = {}
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                if currentIndex != 0 {
                    Button("Back") {
                        withAnimation(.easeInOut) {
                            self.currentIndex -= 1
                        }
                    }
                } else {Text("")}
                Spacer()
                if (currentIndex != 1) {
                    Button("Далее") {
                        withAnimation(.easeInOut) {
                            currentIndex += 1
                        }
                    }
                } else {
                    Button("Готово") {
                        self.userSettingsVM.saveUserSettings()
                        self.completion()
                    }
                }
            }.padding()
            if currentIndex == 0 {
                ScreenView(currentIndex: 0,
                           title: ScreenTitles.startDate.rawValue,
                           details: ScreenTitles.startDate.details) {
                    DatePicker("", selection: $userSettingsVM.startDate,
                               in: Date()...Date().addingTimeInterval(Double(DateConstants.dayInSeconds)*30.00), displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, .init(identifier: "ru_RU"))
                        .frame(width: UIScreen.main.bounds.width - 32, alignment: .center)
                }.transition(.scale)
            }
            if currentIndex == 1 {
                ScreenView(currentIndex: 1,
                           title: ScreenTitles.schedule.rawValue,
                           details: ScreenTitles.startDate.details) {
                    DaysCountPicker(workingDays: $userSettingsVM.countOfWorkingDays, restDays: $userSettingsVM.countOfRestDays)
                        .frame(height: UIScreen.main.bounds.size.height * 0.2)
                    
                }.transition(.scale)
            }
        }
    }
    init(completion: @escaping ()->() = {}) {
        self.completion = completion
    }
    
    public enum ScreenTitles: String
    {
        case startDate = "Когда у вас ближайшая смена?"
        case schedule = "Какой у вас рабочий график?"
        
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
