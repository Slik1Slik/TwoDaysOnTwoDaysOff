//
//  Sidebar.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.01.2022.
//

import SwiftUI

struct Sidebar: View {
    
    @ObservedObject private var colorThemeSettingsViewModel = ColorThemeSettingsViewModel()
    
    @State private var isScheduleChangingAlertPresented = false
    @State private var isThemeDetailsSheetPresented = false
    @State private var isExceptionDetailsSheetPresented = false
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.calendarColorPalette) var calendarColorPalette
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectPadding(16)) {
            applicationTitle
            LazyVStack(spacing: LayoutConstants.perfectPadding(16), pinnedViews: .sectionHeaders) {
                exceptionsSection
                designSection
                scheduleSection
            }
            Spacer()
        }
        .padding(.top, LayoutConstants.perfectPadding(8))
        .padding(.horizontal, LayoutConstants.perfectPadding(16))
        .alert(isPresented: $isScheduleChangingAlertPresented) {
            Alert(title: Text("Предупреждение"),
                  message: alertMessageText,
                  primaryButton: .cancel(alertPrimaryButtonLabel),
                  secondaryButton: .destructive(alertSecondaryButtonLabel, action: alertSecondaryButtonAction))
        }
        .sheet(isPresented: $isThemeDetailsSheetPresented) {
            NavigationView {
                SaveColorThemeView()
                    .environment(\.colorPalette, colorPalette)
                    .environmentObject(colorThemeSettingsViewModel.colorThemeDetailsViewModel)
            }
        }
        .sheet(isPresented: $isExceptionDetailsSheetPresented) {
            NavigationView {
                ExceptionDetailsView(date: Date())
                    .environment(\.colorPalette, colorPalette)
                    .environmentObject(colorThemeSettingsViewModel.colorThemeDetailsViewModel)
            }
        }
    }
    
    private var applicationTitle: some View {
        Text("2/2")
            .font(.title.bold())
            .foregroundColor(colorPalette.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var exceptionsSection: some View {
        Section {
            NavigationLink {
                LazyView(
                    ExceptionsListView()
                        .environment(\.colorPalette, colorPalette)
                        .environment(\.calendarColorPalette, calendarColorPalette)
                )
            } label: {
                sidebarItemLabel(title: SidebarItem.exceptionsList.title)
            }
        } header: {
            sidebarSectionLabel(iconName: SidebarSection.exceptions.iconName,
                                title: SidebarSection.exceptions.title) {
                Button {
                    isExceptionDetailsSheetPresented = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(colorPalette.textSecondary)
                }
            }
        }
    }
    
    private var designSection: some View {
        Section {
            VStack {
                NavigationLink {
                    LazyView(
                        SettingsView()
                            .environment(\.colorPalette, colorPalette)
                    )
                } label: {
                    sidebarItemLabel(title: SidebarItem.colorThemeSettings.title)
                }
                .foregroundColor(colorPalette.buttonSecondary)
                
                if !colorThemeSettingsViewModel.isCurrentColorThemeDefault {
                    Button {
                        isThemeDetailsSheetPresented = true
                        colorThemeSettingsViewModel.updateTheme()
                    } label: {
                        sidebarItemLabel(title: SidebarItem.changeCurrentColorTheme.title)
                    }
                    .foregroundColor(colorPalette.buttonSecondary)
                }
            }
        } header: {
            sidebarSectionLabel(iconName: SidebarSection.design.iconName, title: SidebarSection.design.title) {
                Button {
                    colorThemeSettingsViewModel.addNewTheme()
                    isThemeDetailsSheetPresented = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(colorPalette.textSecondary)
                }
            }
        }
    }
    
    private var scheduleSection: some View {
        Section {
            Button (action: { isScheduleChangingAlertPresented = true }) {
                sidebarItemLabel(title: SidebarItem.changeSchedule.title)
            }
            .foregroundColor(colorPalette.buttonSecondary)
        } header: {
            sidebarSectionLabel(iconName: SidebarSection.schedule.iconName, title: SidebarSection.schedule.title) {
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    private func sidebarSectionLabel<Content: View>(iconName: String, title: String, trailingButton: @escaping () -> Content) -> some View {
        HStack {
//            Image(systemName: iconName)
//                .renderingMode(.template)
//                .foregroundColor(colorPalette.textSecondary)
            Text(title)
                .font(.title3.bold())
                .foregroundColor(colorPalette.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            trailingButton()
        }
    }
    
    private func sidebarItemLabel(title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(colorPalette.buttonSecondary)
            Spacer()
        }
        .padding(.leading)
    }
    
    private var alertMessageText: Text {
        Text("Вы уверены, что хотите изменить график? Все исключения будут безвозвратно удалены.")
    }
    
    private var alertPrimaryButtonLabel: Text {
        Text("Отмена")
    }
    
    private var alertSecondaryButtonLabel: Text {
        Text("Изменить")
    }
    
    private var alertSecondaryButtonAction: () -> () = {
        withAnimation {
            UserSettings.isCalendarFormed = false
        }
    }
    
    enum SidebarSection: String, CaseIterable {
        case exceptions
        case design
        case schedule
        
        var iconName: String {
            switch self {
            case .exceptions:
                return "list.bullet.rectangle.portrait.fill"
            case .design:
                return "paintbrush.pointed.fill"
            case .schedule:
                return "case.fill"
            }
        }
        
        var title: String {
            switch self {
            case .exceptions:
                return "Исключения"
            case .design:
                return "Оформление"
            case .schedule:
                return "График"
            }
        }
    }
    
    enum SidebarItem: String {
        case exceptionsList
        case colorThemeSettings
        case changeCurrentColorTheme
        case changeSchedule
        
        var title: String {
            switch self {
            case .exceptionsList:
                return "Список исключений"
            case .colorThemeSettings:
                return "Список тем"
            case .changeCurrentColorTheme:
                return "Изменить текущую тему"
            case .changeSchedule:
                return "Изменить график"
            }
        }
    }
    
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
