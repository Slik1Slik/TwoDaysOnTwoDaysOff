//
//  DayViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import Combine
import SwiftUI

class DayViewModel: ObservableObject {
    
    @Published var day: Day?
    @Published var date: Date = DateConstants.date_01_01_1970
    
    @ObservedObject private var exceptionsObserver = RealmObserver(for: Exception.self)
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $date
            .sink { [unowned self] (date) in
                self.day = DaysDataStorageManager.find(by: date)
            }
            .store(in: &cancellableSet)
        exceptionsObserver.onObjectsHaveBeenChanged = { [unowned self] in
            self.day = DaysDataStorageManager.find(by: date)
        }
    }
    
    func day(_ date: Date) -> Day? {
        return DaysDataStorageManager.find(by: date)
    }
}
