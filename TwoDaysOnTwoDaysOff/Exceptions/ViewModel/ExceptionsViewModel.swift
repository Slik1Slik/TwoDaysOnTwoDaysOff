//
//  ExceptionListViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

class ExceptionsViewModel: ObservableObject {
    @Published var exception: Exception?
    @Published var date: Date = Date()
    
    @Published var errorMessage: String = ""
    @Published var isFailed: Bool = false
    
    @ObservedObject private var exceptionsObserver = RealmObserver(for: Exception.self)
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func fetch() -> [Exception] {
        return ExceptionsDataStorageManager.shared.readAll()
    }
    
    func remove() {
        do {
            try ExceptionsDataStorageManager.shared.remove(exception!)
            exception = nil
        } catch let error as NSError {
            isFailed = true
            errorMessage = (error as! ExceptionsDataStorageManagerErrors).localizedDescription
        }
    }
    
    init() {
        $date
            .map { value in
                return ExceptionsDataStorageManager.shared.find(by: value)
            }
            .assign(to: \.exception, on: self)
            .store(in: &cancellableSet)
        
        exceptionsObserver.onObjectsHaveBeenDeleted = { _ in
            self.exception = nil
        }
        exceptionsObserver.onObjectHasBeenInserted = { objects in
            self.exception = realm.objects(Exception.self).last
        }
        exceptionsObserver.onObjectHasBeenModified = { modifiedObject in
            self.exception = modifiedObject
        }
    }
}
