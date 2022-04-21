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
    
    @ObservedObject var colorThemeDetailsViewModel: ColorThemeDetailsViewModel = ColorThemeDetailsViewModel(mode: .add)
    
    @ObservedObject private var directoryObserver = AppDirectoryObserver(url: UserColorThemeManager.shared.colorThemesDirectory)
    
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
        observeDirectory()
    }
    
    deinit {
        directoryObserver.stopObserving()
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
    
    private func observeDirectory() {
        directoryObserver.onDirectoryDidChange = { [weak self] in
            DispatchQueue.main.async {
                withAnimation {
                    self?.onDirectoryHasChanged()
                }
            }
        }
        directoryObserver.startObserving()
    }
}
