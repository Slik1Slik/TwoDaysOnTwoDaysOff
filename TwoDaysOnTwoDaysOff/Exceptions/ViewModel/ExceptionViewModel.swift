//
//  ExceptionViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 20.09.2021.
//

import UIKit
import Combine

class ExceptionViewModel: ObservableObject {
    @Published var from: Date = Date()
    @Published var to: Date = Date()
    @Published var name: String = ""
    @Published var details: String = ""
    @Published var icon: ExceptionIcon = ExceptionIcon()
    @Published var isWorking: Bool = false
    
    @Published var isPeriod: Bool = false
    
    private var exception: Exception?
    
    @Published var isValid: Bool = false
    
    @Published var nameErrorMessage: String = " "
    @Published var detailsErrorMessage: String = " "
    @Published var datesErrorMessage: String = " "
    
    @Published var isSuccessful: Bool = true
    @Published var errorMessage: String = ""
    
    private var isNameFilled: AnyPublisher<Bool, Never> {
        $name
            .map { string in
                return !string.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    private var isNameSymbolsCountCorrect: AnyPublisher<Bool, Never> {
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
    
    private var isNameValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isNameFilled, isNameSymbolsCountCorrect)
            .map { a, b in
                return a == true && b == true
            }
            .eraseToAnyPublisher()
    }
    
    private var isDetailsSymbolsCountCorrect: AnyPublisher<Bool, Never> {
        $details
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { text in
                return text.trimmingCharacters(in: .whitespaces)
            }
            .map { string in
                return string.count < 399
            }
            .eraseToAnyPublisher()
    }
    
    private var isDateFromAvailabe: AnyPublisher<Bool, Never> {
        $from
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { date in
                return ExceptionsDataStorageManager.find(by: date) == nil
            }
            .eraseToAnyPublisher()
    }
    
    private var isDateToAvailabe: AnyPublisher<Bool, Never> {
        $to
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { date in
                return ExceptionsDataStorageManager.find(by: date) == nil
            }
            .eraseToAnyPublisher()
    }
    
    private var areDatesAvailabe: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isDateFromAvailabe, isDateToAvailabe)
            .map { a, b in
                return a && b
            }
            .eraseToAnyPublisher()
    }
    
    private var isIconChosen: AnyPublisher<Bool, Never> {
        $icon
            .map { icon in
                return !icon.isPlaceholder
            }
            .eraseToAnyPublisher()
    }
    
    private var isExceptionValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isNameValid, isDetailsSymbolsCountCorrect, areDatesAvailabe, isIconChosen)
            .map { a, b, c, d in
                return a && b && c && d
            }
            .eraseToAnyPublisher()
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        isNameSymbolsCountCorrect
            .receive(on: RunLoop.main)
            .map { valid in
                return valid ? " " : "Превышено допустимое количество символов."
            }
            .assign(to: \.nameErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        areDatesAvailabe
            .receive(on: RunLoop.main)
            .map { availabe in
                return availabe ? " " : "На выбранный период уже назначено исключение."
            }
            .assign(to: \.datesErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        $isPeriod
            .receive(on: RunLoop.main)
            .map { [weak self] period in
                return self!.from
            }
            .assign(to: \.to, on: self)
            .store(in: &cancellableSet)
        
        $isWorking
            .map { value in
                let icon = ExceptionIcon()
                icon.isWorking = value
                return icon
            }
            .assign(to: \.icon, on: self)
            .store(in: &cancellableSet)
        
        isExceptionValid
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    init(exception: Exception) {
        self.exception = exception
    }
    
    func save() {
        if let _ = exception {
            update()
        } else {
            add()
        }
    }
    
    private func add() {
        do {
            try ExceptionsDataStorageManager.save(newException)
        } catch let error {
            self.errorMessage = (error as! ExceptionsDataStorageManagerErrors).localizedDescription
            self.isSuccessful = false
        }
    }
    
    private func update() {
        do {
            try ExceptionsDataStorageManager.update(&exception!, with: newException)
        } catch let error {
            self.errorMessage = (error as! ExceptionsDataStorageManagerErrors).localizedDescription
            self.isSuccessful = false
        }
    }
    
    private var newException: Exception {
        Exception(
            from: from,
            to: to,
            name: name,
            details: details,
            icon: icon,
            isWorking: true
        )
    }
}
