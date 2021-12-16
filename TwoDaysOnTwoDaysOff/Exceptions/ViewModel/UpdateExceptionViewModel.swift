//
//  UpdateExceptionViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 29.10.2021.
//

import SwiftUI
import Combine

class UpdateExceptionViewModel: ExceptionViewModel {
    private var exception: Exception
    
    override var areDatesAvailable: AnyPublisher<Bool, Never> {
        Publishers.Merge($from, $to)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { [weak self] value in
                guard let foundException = ExceptionsDataStorageManager.shared.find(by: value) else {
                    return true
                }
                let isFoundExceptionSameToEditedException = (foundException.from == self!.exception.from) && (foundException.to == self!.exception.to)
                return isFoundExceptionSameToEditedException
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
        isPeriod = exception.from != exception.to
    }
    
    override func save() {
        do {
            try ExceptionsDataStorageManager.shared.update(&exception, with: newException)
        } catch let error {
            self.errorMessage = (error as! ExceptionsDataStorageManagerErrors).localizedDescription
        }
    }
}
