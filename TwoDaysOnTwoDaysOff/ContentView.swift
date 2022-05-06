//
//  ContentView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isCalendarFormed") var isCalendarFormed: Bool = false
    @AppStorage("colorThemeID") var colorThemeID: String = UserSettings.colorThemeID ?? DefaultColorTheme.monochrome.rawValue
    
    @State private var colorPalette: ColorPalette = ColorPalette()
    @State private var calendarColorPalette: CalendarColorPalette = CalendarColorPalette()
    
    @ObservedObject private var userColorThemesObserver: UserColorThemesObserver = UserColorThemesObserver()
    
    var body: some View
    {
        if isCalendarFormed {
            NavigationView {
                TabView {
                    CalendarView(calendar: DateConstants.calendar,
                                 interval: DateInterval(start: UserSettings.startDate.compare(with: Date().startOfDay).oldest,
                                                        end: UserSettings.finalDate))
                        .tabItem {
                            Image(systemName: AppScreen.schedule.iconName)
                            Text(AppScreen.schedule.title)
                        }
                        .environment(\.colorPalette, colorPalette)
                        .environment(\.calendarColorPalette, calendarColorPalette)
                    ExceptionsListView()
                        .tabItem {
                            Image(systemName: AppScreen.exceptions.iconName)
                            Text(AppScreen.exceptions.title)
                        }
                        .environment(\.colorPalette, colorPalette)
                        .environment(\.calendarColorPalette, calendarColorPalette)
                    SettingsView()
                        .tabItem {
                            Image(systemName: AppScreen.settings.iconName)
                            Text(AppScreen.settings.title)
                        }
                        .environment(\.colorPalette, colorPalette)
                }
                .ifAvailable.tint(colorPalette.buttonPrimary)
                .onChange(of: colorThemeID) { _ in
                    setUpColorPalette()
                }
                .onAppear {
                    setUpColorPalette()
                    observeColorThemes()
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            ScheduleMakerView()
                .environment(\.colorPalette, ApplicationColorPalette.shared)
        }
    }
    
    private func setUpColorPalette() {
        colorPalette = ApplicationColorPalette.shared
        calendarColorPalette = ApplicationColorPalette.calendar
    }
    
    private func observeColorThemes() {
        userColorThemesObserver.onThemeUpdated = { [self] in
            self.setUpColorPalette()
        }
        userColorThemesObserver.startObserving()
    }
    
    private func setUpTabBar() {
        UITabBar.appearance().barTintColor = colorPalette.backgroundPrimary.uiColor
        UITabBar.appearance().isTranslucent = false
        if #available(iOS 15.0, *) {
            let appereance = UITabBarAppearance()
            appereance.backgroundColor = colorPalette.backgroundPrimary.uiColor
            UITabBar.appearance().standardAppearance = appereance
            UITabBar.appearance().scrollEdgeAppearance = appereance
        }
    }
    
    private func setUpNavigationBar() {
        UINavigationBar.appearance().barTintColor = colorPalette.backgroundPrimary.uiColor
    }
    
    init() {
        setUpTabBar()
        setUpNavigationBar()
    }
}

extension ContentView {
    enum AppScreen: CaseIterable {
        case schedule
        case exceptions
        case settings
        
        var title: String {
            switch self {
            case .schedule:
                return "График"
            case .exceptions:
                return "Исключения"
            case .settings:
                return "Настройки"
            }
        }
        
        var iconName: String {
            switch self {
            case .schedule:
                return "calendar"
            case .exceptions:
                return "doc.text.fill"
            case .settings:
                return "gear"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
