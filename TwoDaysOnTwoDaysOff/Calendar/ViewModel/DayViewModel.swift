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
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $date
            .sink { (date) in
                self.day = DaysDataStorageManager.find(by: date)
            }
            .store(in: &cancellableSet)
    }
}
