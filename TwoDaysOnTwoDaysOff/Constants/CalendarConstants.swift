//
//  CalendarConstants.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import UIKit

struct LayoutConstants {
    
    static let safeFrame = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
    
    private static let screen = UIScreen.main.bounds
    
    private static let iPhone8Height: CGFloat = 667.00
    private static let iPhone8Width: CGFloat = 375.00
    
    static func perfectValueForCurrentDeviceScreen(_ input: CGFloat) -> CGFloat {
        let ratio = input / iPhone8Width
        return UIScreen.main.bounds.width * ratio
    }
}

struct BasicCalendarConstants
{
    static let paddingLeft: CGFloat = 16
    static let paddingRight: CGFloat = 16
    static let paddingTop: CGFloat = 16
    static let paddingBottom: CGFloat = 16
    
    static let maximumCalendarWidth: CGFloat = UIScreen.main.bounds.width - BasicCalendarConstants.paddingLeft - BasicCalendarConstants.paddingLeft
    
    static let maximumCalendarHeight: CGFloat = MonthCalendarLayoutConstants.maximumCalendarHeight
}

struct MonthCalendarLayoutConstants
{
    static let minimumLineSpacing: CGFloat = 15
    static let minimumInteritemSpacing: CGFloat = 10
    
    static let paddingLeft: CGFloat = LayoutConstants.perfectValueForCurrentDeviceScreen(16)
    static let paddingRight: CGFloat = LayoutConstants.perfectValueForCurrentDeviceScreen(16)
    static let paddingTop: CGFloat = LayoutConstants.perfectValueForCurrentDeviceScreen(16)
    static let paddingBottom: CGFloat = LayoutConstants.perfectValueForCurrentDeviceScreen(16)
    
    static let itemWidth = (BasicCalendarConstants.maximumCalendarWidth - paddingLeft - paddingRight -  (minimumInteritemSpacing/8))/8
    
    static let exceptionMarkCircleSize: CGFloat = 7

    static let maximumCalendarHeight: CGFloat =
    {
        let rowHeight = itemWidth +
                        minimumLineSpacing

        let headerHeight = itemWidth

        let resultHeight = (rowHeight * 7) + headerHeight + minimumLineSpacing

        return resultHeight
    }()
}
