//
//  ExceptionViewModelProtocol.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 29.10.2021.
//

import SwiftUI
import Combine

protocol ExceptionViewModelProtocol: AnyObject {
    var from: Published<Date> { get set }
    var to: Published<Date> { get set }
    var name: Published<String> { get set }
    var details: Published<String> { get set }
    var isWorking: Published<Bool> { get set }
    
    var isPeriod: Published<Bool> { get set }
    
    var isValid: Published<Bool> { get set }
    
    var nameErrorMessage: Published<String> { get set }
    var detailsErrorMessage: Published<String> { get set }
    var datesErrorMessage: Published<String> { get set }
    
    var cancellableSet: Set<AnyCancellable> { get set }
    
    func save()
    
    var newException: Exception { get }
}
