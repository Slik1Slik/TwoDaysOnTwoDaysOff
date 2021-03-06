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
            errorMessage = "Удаление темы оказалось неуспешным. Пожалуйста, повторите попытку или перезапустите приложение."
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
        guard !isCurrentColorThemeDefault else {
            hasError = true
            errorMessage = "Системные темы не подлежат редактированию."
            return
        }
        colorThemeDetailsViewModel = ColorThemeDetailsViewModel(mode: .update(currentColorTheme.id))
    }
    
    init() {
        fetchThemes()
        getCurrentTheme()
        observeThemes()
        setSubscriptions()
    }
    
    deinit {
        userColorThemesObserver.stopObserving()
    }
    
    private func observeThemes() {
        userColorThemesObserver.onThemeAdded = { [unowned self] in
            DispatchQueue.main.async { [unowned self] in
                onThemesModified()
            }
        }
        userColorThemesObserver.onThemeUpdated = { [unowned self] in
            DispatchQueue.main.async { [unowned self] in
                onThemesModified()
            }
        }
        userColorThemesObserver.onThemeRemoved = { [unowned self] in
            DispatchQueue.main.async { [unowned self] in
                onThemeRemoved()
            }
        }
        userColorThemesObserver.startObserving()
    }
    
    private func onThemesModified() {
        fetchThemes()
        getCurrentTheme()
        setCurrentTheme()
    }
    
    private func onThemeRemoved() {
        let preLastTheme = colorThemes[colorThemes.count - 2]
        colorThemes.removeAll { colorTheme in
            colorTheme.id == currentColorTheme.id
        }
        currentColorTheme = preLastTheme
        setCurrentTheme()
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
    
    private func setSubscriptions() {
        $currentColorTheme
            .map { theme in
                return theme.id == DefaultColorTheme.slik.rawValue || theme.id == DefaultColorTheme.monochrome.rawValue
            }
            .assign(to: \.isCurrentColorThemeDefault, on: self)
            .store(in: &cancellableSet)
    }
}


