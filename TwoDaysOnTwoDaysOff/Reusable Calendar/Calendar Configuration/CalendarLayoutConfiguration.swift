//
//  CalendarLayoutConfiguration.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.10.2021.
//

import UIKit
import SwiftUI

class CalendarLayoutConfiguration {
    var width: CGFloat {
        didSet {
            calculateVerticalPadding()
            calculateHorizontalPadding()
            
            calculateCalendarBodySpacing()
            
            calculateItemSize()
            
            calculateHeaderSize()
            calculateHeaderPadding()
            
            calculateWeekdaysRowSize()
            calculateWeekdaysRowPadding()
            
            calculateCalendarBodySize()
            calculateCalendarBodyPadding()
        }
    }
    var height: CGFloat {
        let header = header.height + header.paddingTop + header.paddingBottom
        let weekdaysRow = weekdaysRow.height + weekdaysRow.paddingTop + weekdaysRow.paddingBottom
        return header + calendarBody.height + weekdaysRow
    }
    
    var paddingTop: CGFloat = 0
    var paddingLeft: CGFloat = 0
    var paddingRight: CGFloat = 0
    var paddingBottom: CGFloat = 0
    
    var calendarBody: CalendarBody = CalendarBody()
    var header: Header = Header()
    var item: Item = Item()
    var weekdaysRow: WeekdaysRow = WeekdaysRow()
    
    private let iPhone8Width: CGFloat = 375.00
    
    private let basicPadding: CGFloat = 16
    
    private func perfectPadding(_ input: CGFloat) -> CGFloat {
        let ratio = input / iPhone8Width
        return width * ratio
    }
    
    private func defaultPadding() -> CGFloat {
        return perfectPadding(basicPadding)
    }
    
    private func calculateHorizontalPadding() {
        paddingLeft = perfectPadding(16)
        paddingRight = perfectPadding(16)
    }
    
    private func calculateVerticalPadding() {
        paddingTop = perfectPadding(16)
        paddingBottom = perfectPadding(16)
    }
    
    private func calculateCalendarBodySpacing() {
        calendarBody.interitemSpacing = perfectPadding(10)
        calendarBody.lineSpacing = calendarBody.interitemSpacing
    }
    
    private func calculateItemSize() {
        item.width = (width - paddingLeft - paddingRight - (calendarBody.interitemSpacing))/8
        item.height = item.width
    }
    
    private func calculateHeaderPadding() {
        header.paddingLeft = perfectPadding(16)
        header.paddingRight = perfectPadding(16)
        
        header.paddingTop = 0
        header.paddingBottom = 0
    }
    
    private func calculateHeaderSize() {
        header.height = item.width
    }
    
    private func calculateWeekdaysRowSize() {
        weekdaysRow.height = item.width
    }
    
    private func calculateWeekdaysRowPadding() {
        weekdaysRow.paddingLeft = perfectPadding(16)
        weekdaysRow.paddingRight = perfectPadding(16)
        weekdaysRow.paddingTop = perfectPadding(16)
        weekdaysRow.paddingBottom = 0
    }
    
    private func calculateCalendarBodyPadding() {
        calendarBody.paddingTop = perfectPadding(16)
        calendarBody.paddingBottom = perfectPadding(16)
        calendarBody.paddingLeft = 0
        calendarBody.paddingRight = 0
    }
    
    private func calculateCalendarBodySize() {
        let allItems = item.height * 6
        let allLineSpacings = calendarBody.lineSpacing * 5
        calendarBody.height = allItems + allLineSpacings + calendarBody.paddingTop + calendarBody.paddingBottom
    }
    
    class CalendarBody {
        var height: CGFloat = CGFloat()
        
        var lineSpacing: CGFloat = 10
        var interitemSpacing: CGFloat = 10
        
        var paddingTop: CGFloat = 0
        var paddingBottom: CGFloat = 0
        var paddingLeft: CGFloat = 0
        var paddingRight: CGFloat = 0
        
        var font: Font = .body
    }
    
    class Item {
        var width: CGFloat = CGFloat()
        var height: CGFloat = CGFloat()
    }
    
    class Header {
        var height: CGFloat = CGFloat()
        
        var paddingTop: CGFloat = 0
        var paddingBottom: CGFloat = 0
        var paddingLeft: CGFloat = 0
        var paddingRight: CGFloat = 0
        
        var font: Font = .title.bold()
    }
    
    class WeekdaysRow {
        var height: CGFloat = CGFloat()
        
        var paddingTop: CGFloat = 0
        var paddingBottom: CGFloat = 0
        var paddingLeft: CGFloat = 0
        var paddingRight: CGFloat = 0
        
        var font: Font = .body
    }
    
    init() {
        width = UIScreen.main.bounds.width
        
        calculateHorizontalPadding()
        calculateVerticalPadding()
        
        calculateCalendarBodySpacing()
        
        calculateItemSize()
        
        calculateHeaderSize()
        calculateHeaderPadding()
        
        calculateWeekdaysRowSize()
        calculateWeekdaysRowPadding()
        
        calculateCalendarBodySize()
        calculateCalendarBodyPadding()
    }
    
    init(width: CGFloat) {
        self.width = width
        
        calculateHorizontalPadding()
        calculateVerticalPadding()
        
        calculateCalendarBodySpacing()
        
        calculateItemSize()
        
        calculateHeaderSize()
        calculateHeaderPadding()
        
        calculateWeekdaysRowSize()
        calculateWeekdaysRowPadding()
        
        calculateCalendarBodySize()
        calculateCalendarBodyPadding()
    }
}
