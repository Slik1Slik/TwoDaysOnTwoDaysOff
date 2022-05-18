//
//  ExceptionsDataStorageManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import RealmSwift

class ExceptionsDataStorageManager
{
    static let shared: ExceptionsDataStorageManager = ExceptionsDataStorageManager()
    
    func save(_ exception: Exception) throws
    {
        do {
            try realm.write {
                realm.add(exception)
            }
        } catch {
            throw ExceptionsDataStorageManagerErrors.attemptToWriteWasFailure
        }
    }
    
    func exists(_ exception: Exception) -> Bool
    {
        return Array(realm.objects(Exception.self)).contains { object in
            (object.from...object.to).contains(exception.from) || (object.from...object.to).contains(exception.to)
        }
    }
    
    func exists(exception: Exception, excluding excludedException: Exception) -> Bool
    {
        let objects = realm.objects(Exception.self).filter {
            !($0.from == excludedException.from && $0.to == excludedException.to)
        }
        guard let _ = objects.filter({ (currentException) -> Bool in
            (currentException.from <= exception.from && currentException.to >= exception.from) || (currentException.from <= exception.to && currentException.to >= exception.to)
        }).first else
        {
            return false
        }
        return true
    }
    
    func exists(date: Date) -> Bool
    {
        Array(realm.objects(Exception.self)).contains { exception in
            (exception.from...exception.to).contains(date)
        }
    }
    
    func readAll() -> Results<Exception>
    {
        return realm.objects(Exception.self)
    }
    
    func update(_ exception: inout Exception, with newException: Exception) throws
    {
        do {
            try realm.write {
                exception.from = newException.from
                exception.to = newException.to
                exception.isWorking = newException.isWorking
                exception.name = newException.name
                exception.details = newException.details
            }
        } catch {
            throw ExceptionsDataStorageManagerErrors.attemptToWriteWasFailure
        }
    }
    
    func find(by date: Date) -> Exception?
    {
        let results = realm.objects(Exception.self).filter { exception in
            (exception.from...exception.to).contains(date)
        }
        return results.first
    }
    
    func filtred(by predicate: NSPredicate) -> [Exception]
    {
        let results = realm.objects(Exception.self).filter(predicate)
        return Array(results)
    }
    
    func filtred(by predicate: NSPredicate) -> Results<Exception>
    {
        return realm.objects(Exception.self).filter(predicate)
    }
    
    func remove(_ exception: Exception) throws
    {
        guard exists(exception) else {
            throw ExceptionsDataStorageManagerErrors.attemptToRemoveWasFailure
        }
        do {
            try realm.write {
                realm.delete(exception)
            }
        } catch {
            throw ExceptionsDataStorageManagerErrors.attemptToRemoveWasFailure
        }
    }
    
    func removeAll() throws
    {
        guard countOfObjects() > 0 else {
            throw ExceptionsDataStorageManagerErrors.attemptToRemoveWasFailure
        }
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            throw ExceptionsDataStorageManagerErrors.attemptToRemoveWasFailure
        }
    }
    
    func countOfObjects() -> Int
    {
        return realm.objects(Exception.self).count
    }
    
    func nearestAvailableDate() -> Date? {
        let firstDateInAvailableInterval = Date().startOfDay.compare(with: UserSettings.startDate).oldest
        guard let _ = readAll().first else {
            return firstDateInAvailableInterval
        }
        
        let daysInterval = DateInterval(start: firstDateInAvailableInterval, end: UserSettings.finalDate)
        
        for availableDate in DateConstants.calendar.generateDates(inside: daysInterval, matching: .init(hour: 0, minute: 0, second: 0)) {
            if !ExceptionsDataStorageManager.shared.exists(date: availableDate) {
                return availableDate
            }
        }
        
        return nil
    }
    
    func updateStorage() throws
    {
        do {
            try realm.write {
                realm.objects(Exception.self).forEach { (exception) in
                    if exception.from < Date().startOfDay {
                        realm.delete(exception)
                    }
                }
            }
        } catch {
            throw ExceptionsDataStorageManagerErrors.attemptToRemoveWasFailure
        }
    }
    
    private init() {
    }
}

enum ExceptionsDataStorageManagerErrors: Error, LocalizedError
{
    case attemptToWriteWasFailure
    case attemptToRemoveWasFailure
    case appendingExceptionConflictsWithCurrent
    case exceptionNotFound
    
    public var localizedDescription: String {
        switch self {
        case .attemptToWriteWasFailure:
            return "Возникла ошибка при записи исключения. Пожалуйста, проверьте введенные данные и попробуйте еще раз."
        case .attemptToRemoveWasFailure:
            return "Возникла ошибка при удалении исключения. Пожалуйста, попробуйте еще раз."
        case .appendingExceptionConflictsWithCurrent:
            return "На выбранный период уже назначено исключение."
        case .exceptionNotFound:
            return "Исключение не существует."
        }
    }
}
