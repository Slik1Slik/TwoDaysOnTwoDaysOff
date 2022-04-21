//
//  ContentView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isCalendarFormed") var isCalendarFormed: Bool = false
    @AppStorage("colorThemeID") var colorThemeID: String = UserSettings.colorThemeID!
    @State private var colorPalette: ColorPalette = ColorPalette()
    @State private var calendarColorPalette: CalendarColorPalette = CalendarColorPalette()
    @State var isShown: Bool = false
    var body: some View
    {
        if isCalendarFormed {
//            TabView {
//                CalendarView(calendar: DateConstants.calendar, interval: DateInterval(start: UserSettings.startDate, end: UserSettings.finalDate))
//                    .tabItem {
//                        Image(systemName: "calendar")
//                    }
//                    .environment(\.colorPalette, colorPalette)
//                    .environment(\.calendarColorPalette, calendarColorPalette)
//                ExceptionsListView()
//                    .tabItem {
//                        Image(systemName: "calendar")
//                    }
//                    .environment(\.colorPalette, colorPalette)
//                    .environment(\.calendarColorPalette, calendarColorPalette)
//                ColorThemeSettingsView()
//                    .tabItem {
//                        Image(systemName: "gear")
//                    }
//                    .environment(\.colorPalette, colorPalette)
//            }
            CalendarView(calendar: DateConstants.calendar, interval: DateInterval(start: UserSettings.startDate, end: UserSettings.finalDate))
                .environment(\.colorPalette, colorPalette)
                .environment(\.calendarColorPalette, calendarColorPalette)
            .onChange(of: colorThemeID) { _ in
                setUpColorPalette()
            }
            .onAppear {
                setUpColorPalette()
            }
        } else {
            ScheduleMakerView()
        }
    }
    
    private func setUpColorPalette() {
        colorPalette = ApplicationColorPalette.shared
        calendarColorPalette = ApplicationColorPalette.calendar
    }
}

extension ContentView {
    
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
