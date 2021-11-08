//
//  ExceptionViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 20.09.2021.
//

import UIKit
import Combine

class ExceptionViewModel: ObservableObject {
    @Published var from: Date = UserSettings.startDate
    @Published var to: Date = Date()
    @Published var name: String = ""
    @Published var details: String = ""
    @Published var isWorking: Bool = false
    
    @Published var isPeriod: Bool = false
    @Published var isDayKindChangable = false
    
    @Published var isValid: Bool = false
    
    @Published var nameErrorMessage: String = " "
    @Published var detailsErrorMessage: String = " "
    @Published var datesErrorMessage: String = " "
    
    @Published var isSuccessful: Bool = true
    @Published var errorMessage: String = ""
    
    internal var isNameFilled: AnyPublisher<Bool, Never> {
        $name
            .map { string in
                return !string.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    internal var isNameSymbolsCountCorrect: AnyPublisher<Bool, Never> {
        $name
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { string in
                return string.trimmingCharacters(in: .whitespaces)
            }
            .map { string in
                return string.count < 49
            }
            .eraseToAnyPublisher()
    }
    
    internal var isNameValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isNameFilled, isNameSymbolsCountCorrect)
            .map { a, b in
                return a == true && b == true
            }
            .eraseToAnyPublisher()
    }
    
    internal var isDetailsSymbolsCountCorrect: AnyPublisher<Bool, Never> {
        $details
            .removeDuplicates()
            .map { text in
                return text.trimmingCharacters(in: .whitespaces)
            }
            .map { string in
                return string.count <= 400
            }
            .eraseToAnyPublisher()
    }
    
    internal var areDatesAvailable: AnyPublisher<Bool, Never> {
        $from
            .combineLatest($to)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { [weak self] from, to in
                guard ExceptionsDataStorageManager.find(by: from) == nil else {
                    return false
                }
                guard self!.isPeriod else {
                    return true
                }
                return ExceptionsDataStorageManager.find(by: to) == nil
            }
            .eraseToAnyPublisher()
    }
    
    internal var isExceptionValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isNameValid, isDetailsSymbolsCountCorrect, areDatesAvailable)
            .map { a, b, c in
                return a && b && c
            }
            .eraseToAnyPublisher()
    }
    
    internal var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        isNameSymbolsCountCorrect
            .receive(on: RunLoop.main)
            .map { valid in
                return valid ? " " : "Превышено допустимое количество символов."
            }
            .assign(to: \.nameErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        areDatesAvailable
            .receive(on: RunLoop.main)
            .map { availabe in
                return availabe ? " " : "На выбранный период уже назначено исключение."
            }
            .assign(to: \.datesErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        //in case if user want to specify the period and then change their mind then the "to" value drops to be equal to "from" value
        $isPeriod
            .combineLatest($from)
            .receive(on: RunLoop.main)
            .map { _, dateFrom in
                return dateFrom
            }
            .assign(to: \.to, on: self)
            .store(in: &cancellableSet)
        
        //if user change the "from" value then the "to" value becomes equal to the "from" value so in case if they want to specify the period, the "to" value wouldn't be earlier then "from" value
        $from
            .combineLatest($isPeriod)
            .receive(on: RunLoop.main)
            .sink { dateFrom, isPeriod in
                if !isPeriod {
                    self.to = dateFrom
                }
            }
            .store(in: &cancellableSet)
        
        //if user add an one-day exception or days from the period have the same kind (working or non-working) then user wouldn't be able to choose the day kind
        Publishers.CombineLatest3($isPeriod, $from, $to)
            .receive(on: RunLoop.main)
            .sink { isPeriod, dateFrom, dateTo in
                guard isPeriod else {
                    self.isWorking = !DaysDataStorageManager.find(by: dateFrom)!.isWorking
                    self.isDayKindChangable = false
                    return
                }
                
                let daysForInterval = DaysDataStorageManager.find(interval: DateInterval(start: dateFrom, end: dateTo))
                let uniqueElements = daysForInterval
                    .map { day in
                        return day.isWorking
                    }
                    .unique
                
                let areDaysKindsForGivenPeriodEqual = uniqueElements.count == 1
                
                if areDaysKindsForGivenPeriodEqual {
                    self.isWorking = !daysForInterval.first!.isWorking
                    self.isDayKindChangable = false
                } else {
                    self.isDayKindChangable = true
                }
            }
            .store(in: &cancellableSet)
        
        isExceptionValid
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    init(data: Data) {
        
    }
    
    func save() {
        do {
            try ExceptionsDataStorageManager.save(newException)
        } catch let error {
            self.errorMessage = (error as! ExceptionsDataStorageManagerErrors).localizedDescription
            self.isSuccessful = false
        }
    }
    
    internal var newException: Exception {
        Exception(
            from: from,
            to: to,
            name: name,
            details: details,
            isWorking: true
        )
    }
}
