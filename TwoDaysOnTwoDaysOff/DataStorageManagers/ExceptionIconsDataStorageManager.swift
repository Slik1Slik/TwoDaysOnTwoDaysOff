//
//  ExceptionIconsDataStorageManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.10.2021.
//

import UIKit
import RealmSwift

class ExceptionIconsDataStorageManager {
    class var shared: ExceptionIconsDataStorageManager {
        get {
            return ExceptionIconsDataStorageManager()
        }
    }
    
    func first() -> ExceptionIcon {
        return realm.objects(ExceptionIcon.self).first!
    }
    
    func icon(id: Int) -> ExceptionIcon? {
        return realm.objects(ExceptionIcon.self).filter { icon in
            return icon.id == id
        }.first
    }
    
    func readAll() -> [ExceptionIcon] {
        let results = realm.objects(ExceptionIcon.self)
        return Array(results)
    }
    
    func icons(isWorking: Bool) -> [ExceptionIcon] {
        return realm.objects(ExceptionIcon.self).filter { icon in
            return icon.isWorking == isWorking
        }
    }
    
    func filtred(by predicate: NSPredicate) -> [ExceptionIcon]
    {
        let results = realm.objects(ExceptionIcon.self).filter(predicate)
        return Array(results)
    }
    
    
    
    private func add(_ icon: ExceptionIcon) throws {
        do {
            try realm.write({
                realm.add(icon)
            })
        } catch {
            throw ExceptionIconsDataStorageManagerErrors.AttemptToWriteWasFailure
        }
    }
    
    func uploadIcons() {
        
    }
    
    func createDefaultIcons() throws {
        guard readAll().isEmpty else {
            return
        }
        let defaultIconsData: Data
        do {
            defaultIconsData = try AppFileManager().loadBundledContent(fromFileNamed: "defaultIcons", withExtension: "json")
        } catch let error {
            throw error
        }
        
        let defaultIcons: [ExceptionIcon]
        
        do {
            defaultIcons = try JSONManager.shared.read(for: ExceptionIcons.self, from: defaultIconsData).icons
        } catch let error {
            throw error
        }
        
        guard !defaultIcons.isEmpty else {
            return
        }
        
        for icon in defaultIcons {
            do {
                try add(icon)
            } catch {
                throw ExceptionIconsDataStorageManagerErrors.AttemptToWriteWasFailure
            }
        }
    }
    
    enum ExceptionIconsDataStorageManagerErrors: Error
    {
        case AttemptToWriteWasFailure
        
        public var localizedDescription: String {
            switch self {
            case .AttemptToWriteWasFailure:
                return "Ошибка при добавлении иконок исключений. Пожалуйста, перезапустите приложение."
            }
        }
    }
}
