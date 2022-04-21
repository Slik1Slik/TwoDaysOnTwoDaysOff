//
//  ColorThemeSettingsView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI

struct ColorThemeSettingsView: View {
    
    @ObservedObject private var viewModel = ColorThemeSettingsViewModel()
    
    @Environment(\.colorPalette) private var colorPalette
    
    @State private var isRemoveCurrentThemeAlertPresented = false
    @State private var isThemeDetailsSheetPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    List {
                        colorThemesCarousel
                        addNewThemeLink
                        if !DefaultColorTheme.allCases.map { $0.theme.id }.contains(viewModel.currentColorTheme.id) {
                            updateCurrentThemeLink
                            removeCurrentThemeButton
                        }
                    }
                } header: {
                    sectionTitle
                }
            }
            .alert(isPresented: $viewModel.hasError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK"), action: {
                    viewModel.hasError = false
                }))
            }
            .background(colorPalette.backgroundForm.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Оформление")
            .alert(isPresented: $isRemoveCurrentThemeAlertPresented) {
                Alert(title: Text("Предупреждение"), message: Text("Вы уверены, что хотите удалить выбранную тему? Отменить это действие будет невозможно."), primaryButton: .cancel(Text("Отмена")), secondaryButton: .destructive(Text("Удалить"), action: {
                    withAnimation {
                        viewModel.remove()
                    }
                }))
            }
            .sheet(isPresented: $isThemeDetailsSheetPresented) {
                NavigationView {
                    SaveColorThemeView()
                        .environment(\.colorPalette, colorPalette)
                        .environmentObject(viewModel.colorThemeDetailsViewModel)
                }
            }
        }
    }
    
    private var sectionTitle: some View {
        Text("ЦВЕТОВАЯ ТЕМА")
            .foregroundColor(.secondary)
            .font(.footnote)
    }
    
    private var colorThemesCarousel: some View {
        CarouselPicker(selection: $viewModel.currentColorTheme, values: viewModel.colorThemes, spacing: 15) { value in
            VStack(spacing: 15) {
                colorThemeLabel(restDayBackground: value.restDayBackground.color, workingDayBackground: value.workingDayBackground.color)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.3))
                colorThemeLabelMarker(isSelected: value.hashValue == viewModel.currentColorTheme.hashValue)
            }
            .padding(.top)
        } onSelect: { value in
            viewModel.currentColorTheme = value
            viewModel.setCurrentTheme()
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
    
    private var addNewThemeLink: some View {
        Button("Добавить новую тему", action: {
            viewModel.addNewTheme()
            isThemeDetailsSheetPresented = true
        })
            .foregroundColor(colorPalette.buttonPrimary)
    }
    
    private var updateCurrentThemeLink: some View {
        Button("Изменить текущую тему", action: {
            viewModel.updateTheme()
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
}

struct ColorThemeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemeSettingsView()
    }
}
