//
//  UserColorThemeManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI
import UIKit

class UserColorThemeManager {
    
    static var shared: UserColorThemeManager {
        get {
            return UserColorThemeManager()
        }
    }
    
    var colorThemesDirectory: URL = AppDirectoryURLs.shared.documentsDirectoryURL()
    
    func readAll() throws -> [ColorTheme] {
        var colorThemes: [ColorTheme] = []
        
        let urls = FileManager.default.enumerator(at: colorThemesDirectory,
                                                        includingPropertiesForKeys: nil,
                                                  options: [.skipsHiddenFiles])?.allObjects as? [URL]
        
        guard var urls = urls else {
            return DefaultColorTheme.allCases.map { $0.theme }
        }
        
        urls.sort { $0.creationDate < $1.creationDate }
        
        for url in urls {
            if url.pathExtension == "json" {
                do {
                    let theme = try JSONManager.shared.read(for: ColorTheme.self, from: url)
                    colorThemes.append(theme)
                } catch {
                    throw UserColorThemeError.readingFailed
                }
            }
        }
        
        return colorThemes
    }
    
    func safeReadAll() -> [ColorTheme] {
        do {
            return try readAll()
        } catch {
            return DefaultColorTheme.allCases.map { $0.theme }
        }
    }
    
    func find(forID id: String) throws -> ColorTheme {
        let url = colorThemesDirectory.appendingPathComponent("\(id).json")
        guard AppFileStatusChecker.shared.exists(file: url) else {
            throw UserColorThemeError.themeNotFound
        }
        do {
            return try JSONManager.shared.read(for: ColorTheme.self, from: url)
        } catch {
            throw UserColorThemeError.readingFailed
        }
    }
    
    func remove(forID id: String) throws {
        let url = colorThemesDirectory.appendingPathComponent("\(id).json")
        guard AppFileStatusChecker.shared.exists(file: url) else {
            throw UserColorThemeError.themeNotFound
        }
        do {
            try AppFileManager.shared.deleteFile(at: url)
            post(UserColorThemeNotifications.themeHasBeenRemoved)
            post(UserColorThemeNotifications.themesHaveBeenChanged)
        } catch {
            throw UserColorThemeError.removingFailed
        }
    }
    
    func save(_ colorTheme: ColorTheme) throws {
        let url = colorThemesDirectory.appendingPathComponent("\(colorTheme.id).json")
        let event: StorageEvent = AppFileStatusChecker.shared.exists(file: url) ? .update : .add
        do {
            try JSONManager.shared.write(colorTheme, to: url)
            if event == .add {
                post(UserColorThemeNotifications.themeHasBeenAdded)
            } else {
                post(UserColorThemeNotifications.themeHasBeenUpdated)
            }
            post(UserColorThemeNotifications.themesHaveBeenChanged)
        } catch {
            throw UserColorThemeError.writingFailed
        }
    }
    
    private func post(_ notification: Notification.Name) {
        NotificationCenter.default.post(name: notification, object: nil)
    }
    
    func createStorageIfNeeded() {
        createDefaultColorThemesDirectoryIfNeeded()
        storeDefaultColorThemesIfNeeded()
    }
    
    private func createDefaultColorThemesDirectoryIfNeeded() {
        
        guard !AppFileStatusChecker.shared.exists(file: colorThemesDirectory) else { return }
        
        if AppFileManager.shared.createFolder(at: colorThemesDirectory) == false {
            let _ = AppFileManager.shared.createFolder(at: colorThemesDirectory)
        }
    }
    
    private func storeDefaultColorThemesIfNeeded() {
        guard !AppFileStatusChecker.shared.exists(file: colorThemesDirectory.appendingPathComponent(DefaultColorTheme.monochrome.rawValue + ".json"))
        else { return }
        
        for colorTheme in DefaultColorTheme.allCases {
            try? save(colorTheme.theme)
        }
    }
    
    init() {
        self.colorThemesDirectory = AppDirectoryURLs.shared.documentsDirectoryURL().appendingPathComponent("Themes", isDirectory: true)
    }
    
    enum UserColorThemeError: Error {
        case themeNotFound
        case readingFailed
        case writingFailed
        case removingFailed
    }
}

enum DefaultColorTheme: String, CaseIterable {
    case monochrome = "Монохром"
    case slik = "Slik"
    
    var theme: ColorTheme {
        var colorTheme = ColorTheme()
        colorTheme.id = self.rawValue
        colorTheme.name = self.rawValue
        switch self {
        case .slik:
            colorTheme.accent = UIColor.systemRed.hsbaComponents
            colorTheme.restDayText = UIColor.white.hsbaComponents
            colorTheme.workingDayText = UIColor.black.hsbaComponents
            colorTheme.restDayBackground = UIColor.systemRed.hsbaComponents
            colorTheme.workingDayBackground = UIColor.systemGray.hsbaComponents
        case .monochrome:
            colorTheme.accent = UIColor.link.hsbaComponents
            colorTheme.restDayText = UIColor.black.hsbaComponents
            colorTheme.workingDayText = UIColor.white.hsbaComponents
            colorTheme.restDayBackground = UIColor.white.hsbaComponents
            colorTheme.workingDayBackground = Color.black.opacity(0.8).uiColor.hsbaComponents
        }
        return colorTheme
    }
    
}

struct UserColorThemeNotifications {
    static let themesHaveBeenChanged = Notification.Name("themesHaveBeenChanged")
    static let themeHasBeenAdded = Notification.Name("themeHasBeenAdded")
    static let themeHasBeenUpdated = Notification.Name("themeHasBeenUpdated")
    static let themeHasBeenRemoved = Notification.Name("themeHasBeenRemoved")
}
