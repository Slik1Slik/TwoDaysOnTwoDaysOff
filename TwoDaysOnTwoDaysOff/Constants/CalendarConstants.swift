//
//  CalendarConstants.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import UIKit

struct LayoutConstants {
    
    static let safeFrame = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
    static let window = UIApplication.shared.windows[0]
    
    static let paddingLeft: CGFloat = 16
    static let paddingRight: CGFloat = 16
    static let paddingTop: CGFloat = 16
    static let paddingBottom: CGFloat = 16
    
    private static let screen = UIScreen.main.bounds
    
    private static let iPhone8Height: CGFloat = 667.00
    private static let iPhone8Width: CGFloat = 375.00
    
    private static let basicPadding: CGFloat = 16
    
    static func perfectPadding(_ input: CGFloat) -> CGFloat {
        let ratio = input / iPhone8Width
        return UIScreen.main.bounds.width * ratio
    }
    
    static func defaultPadding() -> CGFloat {
        return perfectPadding(basicPadding)
    }
}

struct BasicCalendarConstants
{
    static let paddingLeft: CGFloat = 16
    static let paddingRight: CGFloat = 16
    static let paddingTop: CGFloat = 16
    static let paddingBottom: CGFloat = 16
    
    static let insets = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
    
    static let maximumCalendarWidth: CGFloat = UIScreen.main.bounds.width - BasicCalendarConstants.paddingLeft - BasicCalendarConstants.paddingLeft
    
    static let maximumCalendarHeight: CGFloat = MonthCalendarLayoutConstants.maximumCalendarHeight
}

struct MonthCalendarLayoutConstants
{
    static let minimumLineSpacing: CGFloat = 15
    static let minimumInteritemSpacing: CGFloat = 10
    
    static let paddingLeft: CGFloat = LayoutConstants.perfectPadding(16)
    static let paddingRight: CGFloat = LayoutConstants.perfectPadding(16)
    static let paddingTop: CGFloat = LayoutConstants.perfectPadding(16)
    static let paddingBottom: CGFloat = LayoutConstants.perfectPadding(16)
    
    static let itemWidth = (BasicCalendarConstants.maximumCalendarWidth - paddingLeft - paddingRight -  (minimumInteritemSpacing/8))/8
    
    static let headerWidth = BasicCalendarConstants.maximumCalendarWidth
    static let headerHeight = itemWidth
    
    static let exceptionMarkCircleSize: CGFloat = 7
    
    static let pageHeight = UIScreen.main.bounds.height
    static let pageWidth = UIScreen.main.bounds.width

    static let maximumCalendarHeight: CGFloat =
    {
        let rowHeight = itemWidth +
                        minimumLineSpacing

        let headerHeight = itemWidth

        let resultHeight = (rowHeight * 7) + headerHeight + minimumLineSpacing

        return resultHeight
    }()
}
