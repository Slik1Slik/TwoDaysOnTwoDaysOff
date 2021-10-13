//
//  ExceptionIconViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.10.2021.
//

import UIKit
import Combine

class ExceptionIconViewModel: ObservableObject {
    @Published var exceptionIcon: ExceptionIcon = ExceptionIconsDataStorageManager.shared.first()
    @Published var id: Int = 0
    
    init() {
//        $id
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .flatMap { (id: String) -> AnyPublisher<ExceptionIcon, Never>
//                return ExceptionIconsDataStorageManager.shared.icon(id: id)
//            }
            
    }
    
    func fetch() -> [ExceptionIcon] {
        return ExceptionIconsDataStorageManager.shared.readAll()
    }
    
    func icons(isWorking: Bool) -> [ExceptionIcon] {
        return ExceptionIconsDataStorageManager.shared.icons(isWorking ? .working : .nonWorking)
    }
}
