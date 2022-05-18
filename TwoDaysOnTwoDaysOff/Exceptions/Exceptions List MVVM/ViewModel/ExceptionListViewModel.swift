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

class ExceptionListViewModel: ObservableObject {
    @Published var exceptions: Results<Exception> = ExceptionsDataStorageManager.shared.readAll()
    @Published var searchText: String = ""
    
    @Published var selection = ItemSelection.new
    @Published var listMode = ListMode.view
    
    @Published var errorMessage: String = ""
    @Published var hasError: Bool = false
    
    @Published var selectedException: Exception?
    
    var nearestAvailableDate: Date? {
        return ExceptionsDataStorageManager.shared.nearestAvailableDate()
    }
    
    func dateIntervalLabelFor(_ exception: Exception) -> String {
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
    
    @ObservedObject private var exceptionsObserver = RealmObserver(for: Exception.self)
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest3($selection, $listMode, $searchText)
            .receive(on: RunLoop.main)
            .sink { [weak self] _, _, _ in
                DispatchQueue.main.async {
                    self?.queryExceptions()
                }
            }
            .store(in: &cancellableSet)
        
        exceptionsObserver.onObjectsDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.queryExceptions()
            }
        }
    }
    
    func remove(at indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        do {
            try ExceptionsDataStorageManager.shared.remove(exceptions[index])
        } catch let error as ExceptionsDataStorageManagerErrors {
            hasError = true
            errorMessage = error.localizedDescription
        } catch let anyError {
            hasError = true
            errorMessage = anyError.localizedDescription
        }
    }
    
    private func queryExceptions() {
        self.exceptions = ExceptionsDataStorageManager.shared.filtred(by: predicate()).sorted(byKeyPath: "from", ascending: false)
    }
    
    private func predicate() -> NSPredicate {
        var format = ""
        var argumentArray = [Any]()
        switch selection {
        case .new:
            format = "to >= %@"
        case .outbound:
            format = "to < %@"
        }
        argumentArray.removeAll()
        argumentArray.append(Date().startOfDay)
        if listMode == .search {
            format += " AND name CONTAINS[cd] %@ OR details CONTAINS[cd] %@"
            argumentArray.append(searchText.trimmingCharacters(in: .whitespaces))
            argumentArray.append(searchText.trimmingCharacters(in: .whitespaces))
        }
        return NSPredicate(format: format, argumentArray: argumentArray)
    }
    
    enum ItemSelection: Equatable {
        case new
        case outbound
        
        func toggled() -> ItemSelection {
            switch self {
            case .new:
                return .outbound
            case .outbound:
                return .new
            }
        }
    }
}
