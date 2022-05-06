//
//  UpdateExceptionViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 29.10.2021.
//

import SwiftUI
import Combine

class UpdateExceptionViewModel: ExceptionDetailsViewModel {
    var exception: Exception
    override var areDatesAvailable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($from, $to)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { [unowned self] from, to in
                
                if (from == exception.from) && (to == exception.to) { return true }
                
                let interval = DateInterval(start: from, end: to.endOfDay)
                for date in DateConstants.calendar.generateDates(inside: interval, matching: .init(hour: 0, minute: 0, second: 0)) {
                    if let foundException = ExceptionsDataStorageManager.shared.find(by: date) {
                        if foundException != exception {
                            return false
                        }
                    }
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }

    init(date: Date) {
        exception = ExceptionsDataStorageManager.shared.find(by: date)!
        super.init()
        from = exception.from
        to = exception.to
        name = exception.name
        details = exception.details
        isWorking = exception.isWorking
        isPeriod = exception.from < exception.to
    }
    
    override func save() {
        lastCheckBeforeSaving()
        if !hasError {
            do {
                try ExceptionsDataStorageManager.shared.update(&exception, with: newException)
            } catch let error as ExceptionsDataStorageManagerErrors {
                self.anyErrorMessage = error.localizedDescription
            } catch let anyError {
                self.anyErrorMessage = anyError.localizedDescription
            }
        }
    }
}
