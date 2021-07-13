//
//  ExceptionsDataStorageManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class ExceptionsDataStorageManager
{
    static func save(_ exception: Exception) throws
    {
        guard !conflicts(exception) else {
            throw ExceptionsDataStorageManagerErrors.AppendingExceptionConflictsWithCurrent
        }
        try! realm.write {
            realm.add(exception)
        }
    }
    
    private static func conflicts(_ exception: Exception) -> Bool
    {
        let query = "(from <= %@ AND to >= %@) OR (from <= %@ AND to >= %@)"
        guard let _ = realm.objects(Exception.self).filter(query,
                                                           exception.from, exception.from,
                                                           exception.to, exception.to).first else
        {
            return false
        }
        return true
    }
    
    private static func conflicts(exception: Exception, excluding excludedException: Exception) -> Bool
    {
        let objects = realm.objects(Exception.self).filter {
            !($0.from == excludedException.from && $0.to == excludedException.to)
        }
        print(objects)
        guard let _ = objects.filter({ (currentException) -> Bool in
            (currentException.from <= exception.from && currentException.to >= exception.from) || (currentException.from <= exception.to && currentException.to >= exception.to)
        }).first else
        {
            return false
        }
        return true
    }
    
    static func readAll() throws -> [Exception]
    {
        let results = realm.objects(Exception.self)
        return Array(results)
    }
    
    static func update(_ exception: inout Exception, with newException: Exception) throws
    {
        guard !conflicts(exception: newException, excluding: exception) else {
            throw ExceptionsDataStorageManagerErrors.AppendingExceptionConflictsWithCurrent
        }
        try! realm.write {
            exception.from = newException.from
            exception.to = newException.to
            exception.isWorking = newException.isWorking
            exception.name = newException.name
            exception.details = newException.details
        }
    }
    
    static func find(by date: Date) throws -> Exception
    {
        let results = realm.objects(Exception.self).filter("from <= %@ AND to >= %@", date, date)
        guard let exception = results.first else {
            throw ExceptionsDataStorageManagerErrors.NoResultForQuery
        }
        return exception
    }
    
    static func filtred(by predicate: NSPredicate) throws -> [Exception]
    {
        let results = realm.objects(Exception.self).filter(predicate).map{ $0 }
        guard !results.isEmpty else {
            throw ExceptionsDataStorageManagerErrors.NoResultForQuery
        }
        return Array(results)
    }
    
    static func remove(_ exception: Exception)
    {
        try! realm.write {
            realm.delete(exception)
        }
    }
    
    static func countOfObjects() -> Int
    {
        return realm.objects(Exception.self).count
    }
    
    static func updateStorage()
    {
        try! realm.write {
            realm.objects(Exception.self).forEach { (exception) in
                if exception.from < Date().short() {
                    realm.delete(exception)
                }
            }
        }
    }
}

enum ExceptionsDataStorageManagerErrors: Error
{
    case AttemptToWriteWasFailure
    case NoResultForQuery
    case AppendingExceptionConflictsWithCurrent
}
