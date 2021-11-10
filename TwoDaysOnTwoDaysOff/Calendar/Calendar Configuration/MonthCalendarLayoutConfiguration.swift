//
//  MonthCalendarConfiguration.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.10.2021.
//

import UIKit
import SwiftUI

class MonthCalendarLayoutConfiguration {
    var width: CGFloat {
        didSet {
            configureSpacing()
            configureHorizontalPadding()
            cofigureItem()
            configureHeader()
            configureHeight()
            configureVerticalPadding()
        }
    }
    var height: CGFloat = 400
    
    var lineSpacing: CGFloat = 10
    var interitemSpacing: CGFloat = 10
    
    var paddingTop: CGFloat = 0
    var paddingLeft: CGFloat = 0
    var paddingRight: CGFloat = 0
    var paddingBottom: CGFloat = 0
    
    var header: Header = Header()
    var item: Item = Item()
    var weekdaysRow: WeekdaysRow = WeekdaysRow()
    
    private func configureSpacing() {
        interitemSpacing = width * 0.027
        lineSpacing = interitemSpacing
    }
    
    private func configureHorizontalPadding() {
        paddingLeft = width * 0.043
        paddingRight = width * 0.043
    }
    
    private func cofigureItem() {
        item.width = (width - paddingLeft - paddingRight - (interitemSpacing/8))/8
        item.height = item.width
    }
    
    private func configureHeader() {
        header.height = item.width
        
        header.paddingLeft = paddingLeft
        header.paddingRight = paddingRight
        
        header.paddingTop = 0
        header.paddingBottom = paddingLeft
    }
    
    private func configureWeekdaysRow() {
        weekdaysRow.height = item.width
        
        weekdaysRow.paddingLeft = paddingLeft
        weekdaysRow.paddingRight = paddingRight
    }
    
    private func configureHeight() {
        let allItems = item.height * 6
        let allLineSpacings = lineSpacing * 5
        height = allItems + allLineSpacings + weekdaysRow.height + weekdaysRow.paddingBottom
    }
    
    private func configureVerticalPadding() {
        paddingTop = paddingLeft
        paddingBottom = paddingRight
    }
    
    class Header {
        var height: CGFloat = CGFloat()
        
        var paddingTop: CGFloat = 0
        var paddingBottom: CGFloat = 0
        var paddingLeft: CGFloat = 0
        var paddingRight: CGFloat = 0
    }
    
    class Item {
        var width: CGFloat = CGFloat()
        var height: CGFloat = CGFloat()
        
        var paddingTop: CGFloat = 0
        var paddingBottom: CGFloat = 0
        var paddingLeft: CGFloat = 0
        var paddingRight: CGFloat = 0
    }
    
    class WeekdaysRow {
        var height: CGFloat = CGFloat()
        
        var paddingTop: CGFloat = 0
        var paddingBottom: CGFloat = 0
        var paddingLeft: CGFloat = 0
        var paddingRight: CGFloat = 0
    }
    
    init() {
        width = UIScreen.main.bounds.width
        
        configureSpacing()
        configureHorizontalPadding()
        cofigureItem()
        configureHeader()
        configureHeight()
        configureVerticalPadding()
    }
    
    init(width: CGFloat) {
        self.width = width
        
        configureSpacing()
        configureHorizontalPadding()
        cofigureItem()
        configureHeader()
        configureHeight()
        configureVerticalPadding()
    }
}

extension MonthCalendarLayoutConfiguration {
    enum LayoutConfiguration {
        case expanded
        case alert
    }
}
