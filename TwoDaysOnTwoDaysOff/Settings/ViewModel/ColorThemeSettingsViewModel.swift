//
//  ColorPaletteSettingsViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI
import Combine

class ColorThemeSettingsViewModel: ObservableObject {
    
    @Published private(set) var colorThemes: [ColorTheme] = []
    @Published var currentColorTheme: ColorTheme = ColorTheme()
    
    @Published var isCurrentColorThemeDefault: Bool = true
    
    @ObservedObject var colorThemeDetailsViewModel: ColorThemeDetailsViewModel = ColorThemeDetailsViewModel(mode: .add)
    
    @ObservedObject private var userColorThemesObserver: UserColorThemesObserver = UserColorThemesObserver()
    
    var hasError: Bool = false
    var errorMessage: String = ""
    
    private var cancellableSet = Set<AnyCancellable>()
    
    func remove() {
        do {
            try UserColorThemeManager.shared.remove(forID: currentColorTheme.id)
        } catch {
            hasError = true
            errorMessage = "Removing theme failed. Please try again"
            currentColorTheme = colorThemes.last ?? DefaultColorTheme.monochrome.theme
            setCurrentTheme()
        }
    }
    
    func setCurrentTheme() {
        UserSettings.colorThemeID = currentColorTheme.id
    }
    
    func addNewTheme() {
        colorThemeDetailsViewModel = ColorThemeDetailsViewModel(mode: .add)
    }
    
    func updateTheme() {
        colorThemeDetailsViewModel = ColorThemeDetailsViewModel(mode: .update(currentColorTheme.id))
    }
    
    init() {
        fetchThemes()
        getCurrentTheme()
        observeThemes()
        setSubscriptions()
    }
    
    private func observeThemes() {
        userColorThemesObserver.onAnyChange = { [unowned self] in
            fetchThemes()
            getCurrentTheme()
            setCurrentTheme()
        }
        userColorThemesObserver.startObserving()
    }
    
    private func fetchThemes() {
        colorThemes = UserColorThemeManager.shared.safeReadAll()
    }
    
    private func getCurrentTheme() {
        guard let currentThemeID = UserSettings.colorThemeID else { return }
        do {
            currentColorTheme = try UserColorThemeManager.shared.find(forID: currentThemeID)
        } catch {
            currentColorTheme = colorThemes.last ?? DefaultColorTheme.monochrome.theme
        }
    }
    
    private func onDirectoryHasChanged() {
        fetchThemes()
        getCurrentTheme()
        setCurrentTheme()
    }
    
    private func setSubscriptions() {
        $currentColorTheme
            .map { theme in
                return theme.id == DefaultColorTheme.slik.rawValue || theme.id == DefaultColorTheme.monochrome.rawValue
            }
            .assign(to: \.isCurrentColorThemeDefault, on: self)
            .store(in: &cancellableSet)
    }
}


