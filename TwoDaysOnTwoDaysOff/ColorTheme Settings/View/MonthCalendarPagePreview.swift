//
//  MonthCalendarPagePreview.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.04.2022.
//

import SwiftUI

struct MonthCalendarPagePreview: View {
    
    private var calendarManager: MonthCalendarManager = MonthCalendarManager()
    
    @ObservedObject private var dayViewModel: MonthPagePreviewViewModel = MonthPagePreviewViewModel()
    
    @EnvironmentObject private var colorThemeViewModel: ColorThemeDetailsViewModel
    
    @Environment(\.colorPalette) private var colorPalette
    
    var body: some View {
        MonthView(month: Date(),
                  calendarManager: calendarManager,
                  showsHeader: false,
                  showsWeekdaysRow: false, dateView: { date in
            dayCell(date: date)
        })
    }
    
    init() {
        let interval = DateInterval(start: dayViewModel.days.first!.date, end: dayViewModel.days.last!.date)
        self.calendarManager = MonthCalendarManager(calendar: DateConstants.calendar,
                                                    interval: interval,
                                                    layoutConfiguration: .expanded)
        calendarManager.layoutConfiguration.calendarBody.paddingBottom = 0
    }
    
    @ViewBuilder
    private func dayCell(date: Date) -> some View {
        if let day = dayViewModel.day(for: date) {
            dateView(date: date, isWorking: day.isWorking)
        }
    }
    
    @ViewBuilder
    private func dateView(date: Date, isWorking: Bool) -> some View {
        DateView(date: date)
            .font(.title3)
            .foregroundColor(isWorking ? colorThemeViewModel.workingDayText : colorThemeViewModel.restDayText)
            .frame(width: calendarManager.layoutConfiguration.item.width,
                   height: calendarManager.layoutConfiguration.item.width)
            .background(isWorking ? colorThemeViewModel.workingDayBackground : colorThemeViewModel.restDayBackground)
            .clipShape(Circle())
    }
}

//struct MonthCalendarPagePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthCalendarPagePreview()
//    }
//}
