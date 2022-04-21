//
//  Schedule.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 12.04.2022.
//

import Foundation

struct Schedule {
    var startDate: Date = Date().short
    var finalDate: Date = Date().short
    
    var countOfWorkingDays: Int = 2
    var countOfRestDays: Int = 2
}
