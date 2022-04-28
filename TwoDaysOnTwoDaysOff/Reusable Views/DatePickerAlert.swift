//
//  CompactMonthCalendarAlert.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 25.04.2022.
//

import SwiftUI

struct DatePickerAlert: View {
    
    var onAccept: (Date) -> () = { _ in }
    
    @ObservedObject private var calendarManager: CalendarManager
    
    @Environment(\.colorPalette) private var colorPalette
    
    var body: some View {
        VStack {
            CompactMonthCalendarView(calendarManager: calendarManager)
            acceptButton
        }
    }
    
    private var acceptButton: some View {
        Button(action: {
            onAccept(calendarManager.selectedDate)
        }) {
            Text("Accept")
                .bold()
                .foregroundColor(colorPalette.buttonPrimary)
                .padding()
                .frame(width: calendarManager.layoutConfiguration.width + calendarManager.layoutConfiguration.paddingRight + calendarManager.layoutConfiguration.paddingLeft)
                .backgroundBlurEffect(style: .systemMaterialLight).clipShape(Capsule())
        }
    }
    
    init(initialDate: Date, range: ClosedRange<Date>, onAccept: @escaping (Date) -> () = { _ in }) {
        self.calendarManager = CalendarManager(calendar: DateConstants.calendar,
                                                    interval: DateInterval(start: range.lowerBound, end: range.upperBound),
                                                    initialDate: initialDate,
                                                    layoutConfiguration: .alert)
        self.calendarManager.selectedDate = initialDate
        self.onAccept = onAccept
    }
}

//struct CompactMonthCalendarAlert_Previews: PreviewProvider {
//    static var previews: some View {
//        DatePickerAlert()
//    }
//}
