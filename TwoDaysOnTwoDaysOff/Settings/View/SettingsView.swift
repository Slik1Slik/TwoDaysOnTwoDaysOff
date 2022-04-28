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
        NavigationView {
            VStack(spacing: 0) {
                header
                    .background(colorPalette.backgroundPrimary.ignoresSafeArea())
                    .zIndex(1.0)
                Divider()
                Form {
                    Section {
                        List {
                            colorThemesCarousel
                            if colorThemeSettingsViewModel.colorThemes.count < 15 {
                                addNewThemeButton
                            }
                            if !DefaultColorTheme.allCases.map { $0.theme.id }.contains(colorThemeSettingsViewModel.currentColorTheme.id) {
                                updateCurrentThemeButton
                                removeCurrentThemeButton
                                    .alert(isPresented: $isRemoveCurrentThemeAlertPresented) {
                                        Alert(title: Text("Предупреждение"),
                                              message: Text("Вы уверены, что хотите удалить выбранную тему? Отменить это действие будет невозможно."),
                                              primaryButton: .cancel(Text("Отмена")),
                                              secondaryButton: .destructive(Text("Удалить"), action: {
                                            withAnimation {
                                                colorThemeSettingsViewModel.remove()
                                            }
                                        }))
                                    }
                            }
                        }
                    } header: {
                        sectionTitle("ОФОРМЛЕНИЕ")
                    }
                    
                    Section {
                        changeScheduleButton
                            .alert(isPresented: $isScheduleChangingAlertPresented) {
                                Alert(title: Text("Предупреждение"),
                                      message: Text("Вы уверены, что хотите изменить график? Все исключения будут безвозвратно удалены."),
                                      primaryButton: .cancel(Text("Отмена")),
                                      secondaryButton: .destructive(Text("Изменить"), action: {
                                    withAnimation {
                                        userSettingsViewModel.dropCurrentUserSettings()
                                    }
                                }))
                            }
                    } header: {
                        sectionTitle("ГРАФИК")
                    }
                }
                .animation(animation)
            }
            .background(colorPalette.backgroundSecondary.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .alert(isPresented: $colorThemeSettingsViewModel.hasError) {
                Alert(title: Text("Error"), message: Text(colorThemeSettingsViewModel.errorMessage), dismissButton: .default(Text("OK"), action: {
                    colorThemeSettingsViewModel.hasError = false
                }))
            }
            .sheet(isPresented: $isThemeDetailsSheetPresented) {
                NavigationView {
                    SaveColorThemeView()
                        .environment(\.colorPalette, colorPalette)
                        .environmentObject(colorThemeSettingsViewModel.colorThemeDetailsViewModel)
                }
            }
        }
    }
    
    private var header: some View {
        Text("Настройки")
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .foregroundColor(.secondary)
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
            colorThemeSettingsViewModel.currentColorTheme = value
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
            isThemeDetailsSheetPresented = true
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
