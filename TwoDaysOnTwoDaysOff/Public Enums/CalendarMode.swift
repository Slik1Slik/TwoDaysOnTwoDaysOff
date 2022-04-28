//
//  CalendarMode Enum.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 27.04.2022.
//

import Foundation

enum CalendarMode {
    case month
    case year
    
    mutating func toggle() {
        switch self {
        case .month:
            self = .year
        case .year:
            self = .month
        }
    }
}
