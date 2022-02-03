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

struct SidebarConstants {
    
}

struct BasicCalendarConstants
{
    static let paddingLeft: CGFloat = 16
    static let paddingRight: CGFloat = 16
    static let paddingTop: CGFloat = 16
    static let paddingBottom: CGFloat = 16
    
    static let insets = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
    
    static let maximumCalendarWidth: CGFloat = UIScreen.main.bounds.width - BasicCalendarConstants.paddingLeft - BasicCalendarConstants.paddingLeft
    
    static let maximumCalendarHeight: CGFloat = ExpandedMonthCalendarConstants.maximumCalendarHeight
}

struct ExpandedMonthCalendarConstants
{
    static let minimumLineSpacing: CGFloat = 15
    static let minimumInteritemSpacing: CGFloat = 10
    
    static let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    
    static let itemWidth = (BasicCalendarConstants.maximumCalendarWidth - sectionInsets.left - sectionInsets.right -  (minimumInteritemSpacing/8))/8
    
    static let headerWidth = BasicCalendarConstants.maximumCalendarWidth
    static let headerHeight = itemWidth
    
    static let pageHeight = UIScreen.main.bounds.height
    static let pageWidth = UIScreen.main.bounds.width
    
    static let paddingTop = pageHeight * 0.078

    static let maximumCalendarHeight: CGFloat =
    {
        let rowHeight = itemWidth +
                        minimumLineSpacing

        let headerHeight = itemWidth

        let resultHeight = (rowHeight * 7) + headerHeight + minimumLineSpacing

        return resultHeight
    }()
}

struct CollapsedMonthCalendarConstants
{
    static let ratio = YearScaledYearCalendarConstants.ratioBetweenExpandedAndCollapsedMonthCalendars
    
    static let minimumLineSpacing: CGFloat =
    {
        let expandedCalendarLineSpacing = ExpandedMonthCalendarConstants.minimumLineSpacing
        
        let result = expandedCalendarLineSpacing * ratio
        
        return result
    }()
    
    static let minimumInteritemSpacing: CGFloat =
    {
        let expandedCalendarInteritemSpacing = ExpandedMonthCalendarConstants.minimumInteritemSpacing
        
        let result = expandedCalendarInteritemSpacing * ratio
        
        return result
    }()
    
    static let sectionInsets: UIEdgeInsets =
    {
        let top: CGFloat    = ExpandedMonthCalendarConstants.sectionInsets.top * ratio
        let bottom: CGFloat = ExpandedMonthCalendarConstants.sectionInsets.bottom * ratio
        let left: CGFloat   = ExpandedMonthCalendarConstants.sectionInsets.left * ratio
        let right: CGFloat  = ExpandedMonthCalendarConstants.sectionInsets.right * ratio
        
        let result = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        
        return result
    }()
    
    static let itemWidth = (YearScaledYearCalendarConstants.itemWidth - sectionInsets.left - sectionInsets.right - (minimumInteritemSpacing/8))/8
    
    static let headerWidth = YearScaledYearCalendarConstants.itemWidth
    static let headerHeight = itemWidth
}

struct MonthScaledYearCalendarConstants
{
    static let minimumLineSpacing: CGFloat = 0
    static let minimumInteritemSpacing: CGFloat = 0
    
    static let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    static let itemWidth = BasicCalendarConstants.maximumCalendarWidth
    static let itemHeight = ExpandedMonthCalendarConstants.maximumCalendarHeight
}

struct YearScaledYearCalendarConstants
{
    static let minimumLineSpacing: CGFloat = 5
    static let minimumInteritemSpacing: CGFloat = 5
    
    static let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    static let itemWidth = (BasicCalendarConstants.maximumCalendarWidth - sectionInsets.right - sectionInsets.left - minimumInteritemSpacing - (minimumInteritemSpacing/3))/3
    
    static let ratioBetweenExpandedAndCollapsedMonthCalendars: CGFloat = itemWidth / MonthScaledYearCalendarConstants.itemWidth
    
    static let itemHeight: CGFloat =
    {
        let maximumHeight = MonthScaledYearCalendarConstants.itemHeight
        
        let minimumHeight = ratioBetweenExpandedAndCollapsedMonthCalendars * maximumHeight
        
        return minimumHeight
    }()
}
