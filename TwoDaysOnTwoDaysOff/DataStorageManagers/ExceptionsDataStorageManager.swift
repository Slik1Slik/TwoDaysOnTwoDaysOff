//
//  ExceptionsDataStorageManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import RealmSwift

let realm = try! Realm(queue: .main)

class ExceptionsDataStorageManager
{
    class var shared: ExceptionsDataStorageManager {
        get {
            return ExceptionsDataStorageManager()
        }
    }
    
    func save(_ exception: Exception) throws
    {
        do {
            try realm.write {
                realm.add(exception)
            }
        } catch {
            throw ExceptionsDataStorageManagerErrors.AttemptToWriteWasFailure
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
            throw ExceptionsDataStorageManagerErrors.AttemptToWriteWasFailure
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
            throw ExceptionsDataStorageManagerErrors.AttemptToRemoveWasFailure
        }
        do {
            try realm.write {
                realm.delete(exception)
            }
        } catch {
            throw ExceptionsDataStorageManagerErrors.AttemptToRemoveWasFailure
        }
    }
    
    func countOfObjects() -> Int
    {
        return realm.objects(Exception.self).count
    }
    
    func updateStorage()
    {
        try! realm.write {
            realm.objects(Exception.self).forEach { (exception) in
                if exception.from < Date().short {
                    realm.delete(exception)
                }
            }
        }
    }
}

enum ExceptionsDataStorageManagerErrors: Error, LocalizedError
{
    case AttemptToWriteWasFailure
    case AttemptToRemoveWasFailure
    case AppendingExceptionConflictsWithCurrent
    case ExceptionNotFound
    
    public var localizedDescription: String {
        switch self {
        case .AttemptToWriteWasFailure:
            return "Ошибка при записи исключения. Пожалуйста, попробуйте еще раз."
        case .AttemptToRemoveWasFailure:
            return "Ошибка при удалении исключения. Пожалуйста, попробуйте еще раз."
        case .AppendingExceptionConflictsWithCurrent:
            return "На выбранный период уже назначено исключение."
        case .ExceptionNotFound:
            return "Исключение не существует."
        }
    }
}
