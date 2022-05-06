//
//  ExceptionDetailsPreviewViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.04.2022.
//

import Combine
import SwiftUI

class ExceptionDetailsPreviewViewModel: ObservableObject {
    var name: String = ""
    var from: Date = Date()
    var to: Date = Date()
    var isWorking: Bool = false
    var details: String = ""
    
    @Published var date: Date = Date()
    
    private var exception = Exception()
    
    var exceptionDateIntervalLabel: String {
        guard from != to else { return from.string(format: "EEEE, d MMMM, YYYY") }
        
        let datesInSameMonth = from.monthNumber == to.monthNumber
        let datesInSameYear = from.yearNumber == to.yearNumber
        
        var dateFromFormat = datesInSameMonth ? "d" : "d MMMM"
        
        if !datesInSameYear {
            dateFromFormat += ", YYYY"
        }
        
        let dateToFormat = "d MMMM, YYYY"
        
        let dateFrom = from.string(format: dateFromFormat)
        let dateTo = to.string(format: dateToFormat)
        
        return dateFrom + " - " + dateTo
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $date
            .sink { [unowned self] date in
                guard let foundException = ExceptionsDataStorageManager.shared.find(by: date) else {
                    return
                }
                self.exception = foundException
                
                self.name = exception.name
                self.from = exception.from
                self.to = exception.to
                self.isWorking = exception.isWorking
                self.details = exception.details
            }
            .store(in: &cancellableSet)
    }
}
