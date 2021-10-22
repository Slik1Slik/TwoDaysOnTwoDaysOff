//
//  MonthCalendarConfiguration.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.10.2021.
//

import UIKit
import SwiftUI

class MonthCalendarConfiguration {
    var width: CGFloat
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
        
        header.topInset = self.lineSpacing
        header.bottomInset = self.lineSpacing
    }
    
    private func configureWeekdaysRow() {
        weekdaysRow.height = item.width
        
        weekdaysRow.topInset = self.lineSpacing
        weekdaysRow.bottomInset = self.lineSpacing
    }
    
    private func configureHeight() {
        let rowHeight = item.height + lineSpacing
        height = (rowHeight * 7) + header.height + lineSpacing
    }
    
    private func configureVerticalPadding() {
        paddingTop = height * 0.078
        paddingBottom = height * 0.078
    }
    
    class Header {
        var height: CGFloat = CGFloat()
        
        var topInset: CGFloat = CGFloat()
        var bottomInset: CGFloat = CGFloat()
    }
    
    class Item {
        var width: CGFloat = CGFloat()
        var height: CGFloat = CGFloat()
        
        var topInset: CGFloat = CGFloat()
        var bottomInset: CGFloat = CGFloat()
    }
    
    class WeekdaysRow {
        var height: CGFloat = CGFloat()
        
        var topInset: CGFloat = CGFloat()
        var bottomInset: CGFloat = CGFloat()
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
