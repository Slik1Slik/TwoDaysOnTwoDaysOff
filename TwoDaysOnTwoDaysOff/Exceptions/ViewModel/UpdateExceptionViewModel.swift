//
//  UpdateExceptionViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 29.10.2021.
//

import SwiftUI
import Combine

class UpdateExceptionViewModel: ExceptionViewModel {
    private var exception: Exception = Exception()
    
    override var areDatesAvailable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($from, $to)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { [weak self] from, to in
                guard from != self!.exception.from && to != self!.exception.to else {
                    return true
                }
                guard let _ = ExceptionsDataStorageManager.find(by: from) else {
                    return false
                }
                guard self!.isPeriod else {
                    return true
                }
                return ExceptionsDataStorageManager.find(by: to) == nil
            }
            .eraseToAnyPublisher()
    }

    init(date: Date) {
        exception = ExceptionsDataStorageManager.find(by: date)!
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
            try ExceptionsDataStorageManager.update(&exception, with: newException)
        } catch let error {
            self.errorMessage = (error as! ExceptionsDataStorageManagerErrors).localizedDescription
            self.isSuccessful = false
        }
    }
}
