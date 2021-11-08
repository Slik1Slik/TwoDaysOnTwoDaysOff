//
//  DateViewProtocol.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.11.2021.
//

import SwiftUI

protocol DateViewProtocol: View, MonthCalendarAccess {
    var date: Date { get set }
    
    init(date: Date, calendarManager: MonthCalendarManager)
}
