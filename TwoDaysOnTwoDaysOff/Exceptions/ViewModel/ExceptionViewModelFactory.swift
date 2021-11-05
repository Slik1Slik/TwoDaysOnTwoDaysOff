//
//  ExceptionViewModelFactory.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 30.10.2021.
//

import Foundation

class ExceptionViewModelFactory {
    private var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    func viewModel() -> ExceptionViewModel {
        if ExceptionsDataStorageManager.exists(date: date) {
            return UpdateExceptionViewModel(date: date)
        } else {
            let vm = AddExceptionViewModel()
            vm.from = date
            return vm
        }
    }
}
