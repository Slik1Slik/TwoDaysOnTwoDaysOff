//
//  ExceptionListViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import SwiftUI
import Combine

class ExceptionListViewModel: ObservableObject {
    var exceptions: [Exception] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
}
