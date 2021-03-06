//
//  ColorPaletteSettingsViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI
import Combine

class ColorThemeDetailsViewModel: ObservableObject {
    
    @Published var name: String = ""
    
    @Published var accent: Color = .blue
    
    @Published private(set) var restDayText: Color = .white
    @Published private(set) var workingDayText: Color = .black
    
    @Published var restDayBackground: Color = .red
    @Published var workingDayBackground: Color = .red
    
    @Published var currentColorThemeComponentToChange: ColorThemeComponent = .restDayBackground
    
    var mode: ColorThemeDetailsViewMode
    
    var setThemeAsCurrent: Bool = true
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    
    var isValid: Bool = true
    
    private var colorTheme: ColorTheme = ColorTheme()
    
    private var cancellableSet = Set<AnyCancellable>()
    
    func save() {
        setColorTheme()
        
        switch mode {
        case .add:
            addTheme()
        case .update(_):
            updateTheme()
        }
    }
    
    private func addTheme() {
        colorTheme.id = UUID().uuidString
        do {
            try UserColorThemeManager.shared.save(colorTheme)
            if setThemeAsCurrent {
                UserSettings.colorThemeID = colorTheme.id
            }
        } catch {
            hasError = true
            errorMessage = "Неизвестная ошибка. Пожалуйста, повторите попытку."
        }
    }
    
    private func updateTheme() {
        do {
            try UserColorThemeManager.shared.save(colorTheme)
        } catch {
            hasError = true
            errorMessage = "Неизвестная ошибка. Пожалуйста, повторите попытку."
        }
    }
    
    init(mode: ColorThemeDetailsViewMode) {
        self.mode = mode
        var colorThemeID = ""
        switch mode {
        case .add:
            colorThemeID = UserSettings.colorThemeID ?? DefaultColorTheme.monochrome.rawValue
        case .update(let id):
            colorThemeID = id
        }
        getColorTheme(forID: colorThemeID)
        setColorThemeParameters()
        setSubscriptions()
    }
    
    private func getColorTheme(forID id: String) {
        do {
            colorTheme = try UserColorThemeManager.shared.find(forID: id)
        } catch {
            UserSettings.colorThemeID = DefaultColorTheme.monochrome.rawValue
        }
    }
    
    private func setColorThemeParameters() {
        self.name = colorTheme.name
        
        self.accent = colorTheme.accent.color
        
        self.restDayText = colorTheme.restDayText.color
        self.workingDayText = colorTheme.workingDayText.color
        
        self.restDayBackground = colorTheme.restDayBackground.color
        self.workingDayBackground = colorTheme.workingDayBackground.color
    }
    
    private func setColorTheme() {
        colorTheme.name = name.trimmingCharacters(in: [" "])
        
        colorTheme.accent = accent.uiColor.hsbaComponents
        
        colorTheme.restDayText = restDayText.uiColor.hsbaComponents
        colorTheme.workingDayText = workingDayText.uiColor.hsbaComponents
        
        colorTheme.restDayBackground = restDayBackground.uiColor.hsbaComponents
        colorTheme.workingDayBackground = workingDayBackground.uiColor.hsbaComponents
    }
    
    private func setSubscriptions() {
        $restDayBackground
            .map { color in
                return color.isDark && !color.isTransparent ? Color.white : Color.black
            }
            .assign(to: \.restDayText, on: self)
            .store(in: &cancellableSet)
        
        $workingDayBackground
            .map { color in
                return color.isDark && !color.isTransparent ? Color.white : Color.black
            }
            .assign(to: \.workingDayText, on: self)
            .store(in: &cancellableSet)
        
        $name
            .map { name in
                return !name.trimmingCharacters(in: [" "]).isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    enum ColorThemeDetailsViewMode: Equatable {
        case add
        case update(String)
    }
    
    enum ColorThemeComponent: String, CaseIterable {
        case restDayBackground = "Выходной день"
        case workingDayBackground = "Рабочий день"
        case accent = "Акцент"
    }
}
