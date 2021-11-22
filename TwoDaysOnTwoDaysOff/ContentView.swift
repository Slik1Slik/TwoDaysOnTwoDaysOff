//
//  ContentView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ContentView: View {
    @State var isCalendarFormed = UserSettings.isCalendarFormed!
    @State var selection = 0
    @Environment(\.isAlertPresented) var isAnyAlertPresented
    @State var brightness: Double = 0
    
    var body: some View
    {
        if isCalendarFormed {
            MonthCalendarView(calendar: DateConstants.calendar, interval: DateInterval(start: UserSettings.startDate, end: UserSettings.finalDate))
            
        } else {
            ScheduleMakerView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ColorPreferenceKey: PreferenceKey {
    static var defaultValue: Color = Color.clear
    
    static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue()
    }
}

extension View {
    @inlinable func hidden(_ hidden: Bool) -> some View {
        if hidden {
            return self.opacity(0)
        } else {
            return self.opacity(1)
        }
    }
}

//UITabBarWrapper([
//    TabBarElement(
//        tabBarElementItem: .init(title: "Home", systemImageName: "calendar"),
//        {
//            MonthCalendarView(interval: DateInterval(start: UserSettings.startDate, end: UserSettings.finalDate))
//        }
//    ),
//    TabBarElement(
//        tabBarElementItem: .init(title: "Exceptions", systemImageName: "doc.plaintext"),
//        {
//            ExceptionsListView()
//        }
//    ),
//    TabBarElement(
//        tabBarElementItem: .init(title: "Settings", systemImageName: "gearshape.2"),
//        {
//            Text("hi")
//        }
//    )
//])
