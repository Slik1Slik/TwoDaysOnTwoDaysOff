//
//  ExceptionViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 20.09.2021.
//

import UIKit
import Combine

class ExceptionDetailsViewModel: ObservableObject {
    @Published var from: Date = UserSettings.startDate {
        willSet {
            if !self.isPeriod {
                to = newValue
            }
        }
    }
    @Published var to: Date = UserSettings.startDate
    @Published var name: String = ""
    @Published var details: String = ""
    @Published var isWorking: Bool = false
    
    @Published var isPeriod: Bool = false {
        //in case if user want to specify the period and then change their mind then the "to" value drops to be equal to "from" value
        willSet {
            if !newValue {
                to = from
            }
        }
    }
    @Published var isDayKindChangable = false
    
    @Published var isValid: Bool = false
    
    @Published var nameErrorMessage: String = " "
    @Published var datesErrorMessage: String = " "
    
    @Published var hasError: Bool = false
    @Published var anyErrorMessage: String = ""
    
    var foundConflictException: Exception?
    
    var nameTextFieldPlaceholder: String {
        var result = defaultnameTextFieldPlaceholder
        
        guard ExceptionsDataStorageManager.shared.countOfObjects() > 3 else { return result }
        
        let exceptions = ExceptionsDataStorageManager.shared.readAll().sorted(by: \.name, ascending: true)
        
        var popularExceptions: [String : Int] = [:]
        
        var maxCount = 0
        
        for exceptionIndex in 0..<exceptions.count {
            if popularExceptions[exceptions[exceptionIndex].name] == nil {
                popularExceptions.updateValue(0, forKey: exceptions[exceptionIndex].name)
            }
            popularExceptions[exceptions[exceptionIndex].name]! += 1
            if maxCount < popularExceptions[exceptions[exceptionIndex].name]! {
                maxCount = popularExceptions[exceptions[exceptionIndex].name]!
                if maxCount > 4 {
                    result = exceptions[exceptionIndex].name
                }
            }
        }
        
        return result
    }
    
    var defaultnameTextFieldPlaceholder: String {
        if isWorking {
            return isDayKindChangable ? "Командировка" : "Подработка"
        } else {
            return isDayKindChangable ? "Отпуск" : "Отгул"
        }
    }
    
    var availableDateIntervalForException: DateInterval {
        let startDate = UserSettings.startDate.compare(with: Date().startOfDay).oldest
        let finalDate = UserSettings.finalDate
        return DateInterval(start: startDate, end: finalDate)
    }
    
    internal var isNameFilled: AnyPublisher<Bool, Never> {
        $name
            .map { string in
                return !string.trimmingCharacters(in: .whitespaces).isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    internal var isNameSymbolsCountCorrect: AnyPublisher<Bool, Never> {
        $name
            .debounce(for: 0.3, scheduler: RunLoop.main)
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
        Publishers.CombineLatest($from, $to)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { [unowned self] from, to in
                guard self.isPeriod else {
                    if let exception = ExceptionsDataStorageManager.shared.find(by: from), !exception.isInvalidated {
                        self.foundConflictException = exception
                        return false
                    }
                    self.foundConflictException = nil
                    return true
                }
                let interval = DateInterval(start: from, end: to.endOfDay)
                for date in DateConstants.calendar.generateDates(inside: interval, matching: .init(hour: 0, minute: 0, second: 0)) {
                    if let exception = ExceptionsDataStorageManager.shared.find(by: date), !exception.isInvalidated {
                        self.foundConflictException = exception
                        return false
                    }
                }
                self.foundConflictException = nil
                return true
            }
            .eraseToAnyPublisher()
    }
    
    internal var areDatesValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($from, $to)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { from, to in
                return from < to || from == to
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
        setSubscriptions()
    }
    
    func save() {
        lastCheckBeforeSaving()
        if !hasError {
            do {
                try ExceptionsDataStorageManager.shared.save(newException)
            } catch let error as ExceptionsDataStorageManagerErrors {
                self.hasError = true
                self.anyErrorMessage = error.localizedDescription
            } catch let anyError {
                self.hasError = true
                self.anyErrorMessage = anyError.localizedDescription
            }
        }
    }
    
    internal func lastCheckBeforeSaving() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty && name.trimmingCharacters(in: .whitespaces).count <= 49 else {
            self.hasError = true
            self.anyErrorMessage = "Название исключения не должно быть пустым, а также не может превышать допустимое количество символов."
            return
        }
        guard from <= to else {
            self.hasError = true
            self.anyErrorMessage = "Введенные даты недействительны. Дата начала исключения не должна быть позднее даты окончания."
            return
        }
        guard availableDateIntervalForException.contains(from) && availableDateIntervalForException.contains(to) else {
            self.hasError = true
            self.anyErrorMessage = "Введенные даты недействительны. Исключение не должно быть назначено на дату ранее текущей или даты, начиная с которой просчитан рабочий график."
            return
        }
    }
    
    private func setSubscriptions() {
        isNameSymbolsCountCorrect
            .receive(on: RunLoop.main)
            .map { valid in
                return valid ? " " : "Превышено допустимое количество символов."
            }
            .assign(to: \.nameErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        areDatesAvailable
            .receive(on: RunLoop.main)
            .map { available in
                return available ? "" : "На выбранный период уже назначено исключение."
            }
            .assign(to: \.datesErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        //if user change the "from" value then the "to" value becomes equal to the "from" value so in case if they want to specify the period, the "to" value won't be earlier then "from" value
        areDatesValid
            .receive(on: RunLoop.main)
            .sink { [unowned self] valid in
                if !valid {
                    self.to = self.from
                }
            }
            .store(in: &cancellableSet)
        
        //if user add an one-day exception or days from the period have the same kind (working or non-working) then user wouldn't be able to choose the day kind
        Publishers.CombineLatest3($isPeriod, $from, $to)
            .receive(on: RunLoop.main)
            .sink { [unowned self] isPeriod, dateFrom, dateTo in
                guard isPeriod else {
                    self.isDayKindChangable = false
                    guard let day = UserDaysDataStorageManager.shared.find(by: dateFrom) else { return }
                    self.isWorking = !day.isWorking
                    return
                }
                let daysForInterval = UserDaysDataStorageManager.shared.find(by: .interval(DateInterval(start: dateFrom, end: dateTo)))
                
                guard daysForInterval.count > 1 else { return }
                
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
    
    internal var newException: Exception {
        Exception(
            from: from,
            to: to,
            name: name.trimmingCharacters(in: .whitespaces),
            details: details.trimmingCharacters(in: .whitespaces),
            isWorking: isWorking
        )
    }
}
