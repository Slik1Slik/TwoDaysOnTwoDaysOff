//
//  UserColorThemeManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI
import UIKit

class UserColorThemeManager {
    class var shared: UserColorThemeManager {
        get {
            UserColorThemeManager()
        }
    }
    
    var colorThemesDirectory: URL = AppDirectoryURLs().documentsDirectoryURL()
    
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
        guard AppFileStatusChecker().exists(file: url) else {
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
        guard AppFileStatusChecker().exists(file: url) else {
            throw UserColorThemeError.themeNotFound
        }
        if !AppFileManager().deleteFile(at: url) {
            throw UserColorThemeError.removingFailed
        }
    }
    
    func add(_ colorTheme: ColorTheme) throws {
        let url = colorThemesDirectory.appendingPathComponent("\(colorTheme.id).json")
        guard !AppFileStatusChecker().exists(file: url) else {
            throw UserColorThemeError.themeAlreadyExists
        }
        do {
            try save(colorTheme)
        } catch let error as UserColorThemeError {
            throw error
        }
    }
    
    func update(_ colorTheme: ColorTheme) throws {
        do {
            try save(colorTheme)
        } catch let error as UserColorThemeError {
            throw error
        }
    }
    
    private func save(_ colorTheme: ColorTheme) throws {
        let url = colorThemesDirectory.appendingPathComponent("\(colorTheme.id).json")
        do {
            try JSONManager.shared.write(colorTheme, to: url)
        } catch {
            throw UserColorThemeError.writingFailed
        }
    }
    
    func createStorageIfNeeded() {
        createDefaultColorThemesDirectoryIfNeeded()
        storeDefaultColorThemesIfNeeded()
    }
    
    private func createDefaultColorThemesDirectoryIfNeeded() {
        
        guard !AppFileStatusChecker().exists(file: colorThemesDirectory) else { return }
        
        if AppFileManager().createFolder(at: colorThemesDirectory) == false {
            let _ = AppFileManager().createFolder(at: colorThemesDirectory)
        }
    }
    
    private func storeDefaultColorThemesIfNeeded() {
        guard !AppFileStatusChecker().exists(file: colorThemesDirectory.appendingPathComponent(DefaultColorTheme.monochrome.rawValue + ".json"))
        else { return }
        
        for colorTheme in DefaultColorTheme.allCases {
            try? save(colorTheme.theme)
        }
    }
    
    init() {
        self.colorThemesDirectory = AppDirectoryURLs().documentsDirectoryURL().appendingPathComponent("Themes", isDirectory: true)
    }
    
    enum UserColorThemeError: Error {
        case themeNotFound
        case themeAlreadyExists
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
