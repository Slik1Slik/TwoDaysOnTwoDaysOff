//
//  AccessoryViewExceptionViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 14.03.2022.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

class AccessoryViewExceptionViewModel: ObservableObject {
    
    var name: String = ""
    var dateFrom: Date = Date()
    var dateTo: Date = Date()
    var details: String = ""
    
    @Published var date: Date = Date()
    
    @Published var errorMessage: String = ""
    @Published var hasError: Bool = false
    
    @Published var exception = Exception()
    
    @Published var exists: Bool = false
    
    @ObservedObject private var exceptionsObserver = RealmObserver(for: Exception.self)
    
    var isValid: Bool {
        !exception.isInvalidated
    }
    
    var exceptionDateIntervalLabel: String {
        guard isValid else { return "" }
        guard exception.from != exception.to else { return exception.from.string(format: "d MMMM, YYYY") }
        
        let datesInSameMonth = exception.from.monthNumber == exception.to.monthNumber
        let datesInSameYear = exception.from.yearNumber == exception.to.yearNumber
        
        var dateFromFormat = datesInSameMonth ? "d" : "d MMMM"
        
        if !datesInSameYear {
            dateFromFormat += ", YYYY"
        }
        
        let dateToFormat = "d MMMM, YYYY"
        
        let dateFrom = exception.from.string(format: dateFromFormat)
        let dateTo = exception.to.string(format: dateToFormat)
        
        return dateFrom + " - " + dateTo
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func remove() {
        do {
            try ExceptionsDataStorageManager.shared.remove(exception)
        } catch let error as ExceptionsDataStorageManagerErrors {
            hasError = true
            errorMessage = error.localizedDescription
        } catch let anyError {
            hasError = true
            errorMessage = anyError.localizedDescription
        }
    }
    
    init() {
        $date
            .sink { [unowned self] date in
                guard let foundException = ExceptionsDataStorageManager.shared.find(by: date), !foundException.isInvalidated else {
                    self.exists = false
                    return
                }
                
                self.exists = true
                
                self.exception = foundException
                
                self.name = exception.name
                self.details = exception.details
                self.dateFrom = exception.from
                self.dateTo = exception.to
            }
            .store(in: &cancellableSet)
        
        exceptionsObserver.onObjectHasBeenInserted = { [unowned self] exception in
            if (exception.from...exception.to).contains(self.date) {
                self.date = exception.from
            } else {
                self.exists = false
            }
        }
        exceptionsObserver.onObjectHasBeenModified = { [unowned self] exception in
            if (exception.from...exception.to).contains(self.date) {
                self.date = exception.from
            } else {
                self.exists = false
            }
        }
        exceptionsObserver.onObjectsHaveBeenDeleted = { [unowned self] _ in
            self.exists = false
        }
    }
}
