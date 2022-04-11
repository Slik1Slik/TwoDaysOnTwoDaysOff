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
    @Published var isFailed: Bool = false
    
    @ObservedObject private var exceptionsObserver = RealmObserver(for: Exception.self)
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest3($selection, $listMode, $searchText)
            .receive(on: RunLoop.main)
            .sink { [unowned self] _, _, _ in
                DispatchQueue.main.async {
                    queryExceptions()
                }
            }
            .store(in: &cancellableSet)
        
        exceptionsObserver.onObjectsHaveBeenChanged = { [unowned self] in
            DispatchQueue.main.async {
                queryExceptions()
            }
        }
    }
    
    func remove(at indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        do {
            try ExceptionsDataStorageManager.shared.remove(exceptions[index])
        } catch {
            fatalError()
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
        argumentArray.append(Date().short)
        if listMode == .search {
            format += " AND name CONTAINS %@ OR details CONTAINS %@"
            argumentArray.append(searchText)
            argumentArray.append(searchText)
        }
        //print(format)
        //print(argumentArray)
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
