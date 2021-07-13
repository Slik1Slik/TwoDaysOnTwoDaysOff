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
                if (currentIndex != 2) {
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
                    .disabled(!userSettingsVM.isValid)
                }
            }.padding()
            if currentIndex == 0 {
                ScreenView(currentIndex: 0,
                           title: ScreenTitles.startDate.rawValue,
                           details: ScreensDetails.startDate.rawValue) {
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
                           details: ScreensDetails.schedule.rawValue) {
                    DaysCountPicker(workingDays: $userSettingsVM.countOfWorkingDays, restDays: $userSettingsVM.countOfRestDays)
                        .frame(height: UIScreen.main.bounds.size.height * 0.2)
                    
                }.transition(.scale)
            }
            if currentIndex == 2 {
                ScreenView(currentIndex: 2,
                           title: ScreenTitles.colors.rawValue,
                           details: ScreensDetails.colors.rawValue) {
                    VStack(alignment: .center) {
                        HStack(alignment: .center, spacing: 10) {
                            Text("Выходные")
                            DaysColorsView(.normal) { (color) in
                                self.userSettingsVM.restDayColor = color
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 0))
                        
                        HStack(alignment: .center, spacing: 10) {
                            Text("Рабочие")
                            DaysColorsView(.reversed) { (color) in
                                self.userSettingsVM.workingDayColor = color
                            }
                        }
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 0))
                        
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.5), lineWidth: 0.4))
                }.transition(.scale)
            }
        }
    }
    init(completion: @escaping ()->() = {}) {
        self.completion = completion
    }
}

struct ScheduleMakerView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleMakerView()
    }
}

public enum ScreenTitles: String
{
    case startDate = "Когда у вас ближайшая смена?"
    case schedule = "Какой у вас рабочий график?"
    case colors = "Цвета дней в календаре"
}

public enum ScreensDetails: String
{
    case startDate = "Если у вас сегодня не выходной, необходимо выбрать первый рабочий день после предстоящих выходных. От этой даты будет рассчитан ваш рабочий год."
    case schedule = "Ваш график, ничего сложного."
    case colors = "Цвета можно будет изменить в дальнейшем."
}
