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
    @Published var isFailed: Bool = false
    
    @Published var exception = Exception()
    
    @ObservedObject private var exceptionsObserver = RealmObserver(for: Exception.self)
    
    var isValid: Bool {
        !exception.isInvalidated && ExceptionsDataStorageManager.shared.exists(exception)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func remove() {
        do {
            try ExceptionsDataStorageManager.shared.remove(exception)
        } catch let error as NSError {
            isFailed = true
            errorMessage = (error as! ExceptionsDataStorageManagerErrors).localizedDescription
        }
    }
    
    init() {
        $date
            .sink { [unowned self] date in
                guard let foundException = ExceptionsDataStorageManager.shared.find(by: date) else {
                    return
                }
                self.exception = foundException
                
                self.name = exception.name
                self.details = exception.details
                self.dateFrom = exception.from
                self.dateTo = exception.to
            }
            .store(in: &cancellableSet)
        
        exceptionsObserver.onObjectHasBeenInserted = { exception in
            self.date = exception.from
        }
        exceptionsObserver.onObjectHasBeenModified = { exception in
            self.date = exception.from
        }
    }
}
