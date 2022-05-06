//
//  ColorThemeSettingsView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @ObservedObject private var colorThemeSettingsViewModel = ColorThemeSettingsViewModel()
    @ObservedObject private var userSettingsViewModel = UserSettingsViewModel()
    
    @Environment(\.colorPalette) private var colorPalette
    
    @State private var isRemoveCurrentThemeAlertPresented = false
    @State private var isThemeDetailsSheetPresented = false
    
    @State private var isScheduleChangingAlertPresented = false
    
    @State private var animation: Animation? = .none
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
                .background(colorPalette.backgroundPrimary.ignoresSafeArea())
                .zIndex(1.0)
            Divider()
            Form {
                Section {
                    List {
                        colorThemesCarousel
                        addNewThemeButton
                        if !colorThemeSettingsViewModel.isCurrentColorThemeDefault {
                            updateCurrentThemeButton
                            removeCurrentThemeButton
                                .ifAvailable.alert(title: "Предупреждение",
                                                   message: Text("Вы уверены, что хотите удалить выбранную тему? Отменить это действие будет невозможно."),
                                                   isPresented: $isRemoveCurrentThemeAlertPresented,
                                                   primaryButtonTitle: Text("Отмена"),
                                                   secondaryButtonTitle: Text("Удалить"),
                                                   primaryButtonAction: { }) {
                                    withAnimation {
                                        colorThemeSettingsViewModel.remove()
                                    }
                                }
                        }
                    }
                } header: {
                    sectionTitle("ОФОРМЛЕНИЕ")
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                Section {
                    changeScheduleButton
                        .ifAvailable.alert(title: "Предупреждение",
                                           message: Text("Вы уверены, что хотите изменить график? Все исключения будут безвозвратно удалены."),
                                           isPresented: $isScheduleChangingAlertPresented,
                                           primaryButtonTitle: Text("Отмена"),
                                           secondaryButtonTitle: Text("Изменить"),
                                           primaryButtonAction: {}) {
                            withAnimation {
                                userSettingsViewModel.dropCurrentUserSettings()
                            }
                        }
                } header: {
                    sectionTitle("ГРАФИК")
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
            }
            .animation(animation)
        }
        .background(colorPalette.backgroundSecondary.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .ifAvailable.alert(title: "Ошибка",
                           message: Text(colorThemeSettingsViewModel.errorMessage),
                           isPresented: $colorThemeSettingsViewModel.hasError,
                           defaultButtonTitle: Text("OK"))
        .sheet(isPresented: $isThemeDetailsSheetPresented) {
            NavigationView {
                SaveColorThemeView()
                    .environment(\.colorPalette, colorPalette)
                    .environmentObject(colorThemeSettingsViewModel.colorThemeDetailsViewModel)
            }
        }
    }
    
    private var navigationBar: some View {
        Text("Настройки")
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
    }
    
    private var colorThemesCarousel: some View {
        CarouselPicker(selection: $colorThemeSettingsViewModel.currentColorTheme, values: colorThemeSettingsViewModel.colorThemes, spacing: 15) { value in
            VStack(spacing: 15) {
                colorThemeLabel(restDayBackground: value.restDayBackground.color, workingDayBackground: value.workingDayBackground.color)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.3))
                colorThemeLabelMarker(isSelected: value.hashValue == colorThemeSettingsViewModel.currentColorTheme.hashValue)
            }
            .animation(.none)
            .onReceive(Just(colorThemeSettingsViewModel.isCurrentColorThemeDefault), perform: { _ in
                animation = .linear
            })
            .padding(.top)
        } onSelect: { value in
            colorThemeSettingsViewModel.setCurrentTheme()
        }
    }
    
    private func colorThemeLabel(restDayBackground: Color, workingDayBackground: Color) -> some View {
        LinearGradient(
            gradient: Gradient(stops: [
                Gradient.Stop(color: restDayBackground, location: 0.5),
                Gradient.Stop(color: workingDayBackground, location: 0.5)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
            .frame(width: 85, height: 85)
            .cornerRadius(8)
    }
    
    private func colorThemeLabelMarker(isSelected: Bool) -> some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
            .foregroundColor(colorPalette.buttonPrimary)
    }
    
    private var addNewThemeButton: some View {
        Button("Добавить новую тему", action: {
            colorThemeSettingsViewModel.addNewTheme()
            isThemeDetailsSheetPresented = true
        })
            .foregroundColor(colorPalette.buttonPrimary)
    }
    
    private var updateCurrentThemeButton: some View {
        Button("Изменить текущую тему", action: {
            colorThemeSettingsViewModel.updateTheme()
            if !colorThemeSettingsViewModel.hasError {
                isThemeDetailsSheetPresented = true
            }
        })
            .foregroundColor(colorPalette.buttonPrimary)
    }
    
    private var removeCurrentThemeButton: some View {
        Button("Удалить текущую тему") {
            isRemoveCurrentThemeAlertPresented = true
        }
        .foregroundColor(colorPalette.buttonPrimary)
    }
    
    private var changeScheduleButton: some View {
        Button (action: { isScheduleChangingAlertPresented = true }) {
            Text("Изменить график")
        }
        .foregroundColor(colorPalette.buttonPrimary)
    }
}

struct ColorThemeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
