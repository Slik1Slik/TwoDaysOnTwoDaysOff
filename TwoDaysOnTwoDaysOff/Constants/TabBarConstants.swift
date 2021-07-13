//
//  TabBarConstants.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 01.07.2021.
//

import UIKit

struct TabBarConstants {
    
    static let paddingTop: CGFloat = 16
    static let paddingBottom: CGFloat = 16
    static let paddingLeading: CGFloat = 10
    static let paddingTrailing: CGFloat = 10
    
    static let spacing: CGFloat = 16
    static let imageTitleSpacing: CGFloat = 3
    
    static let height: CGFloat = 65
    static let width: CGFloat = UIScreen.main.bounds.width + 5
    
    static let itemHeight: CGFloat = 30
    static func itemWidth(count: Int) -> CGFloat {
        let availableWidth = UIScreen.main.bounds.width - paddingLeading - paddingTrailing
        return (availableWidth - (spacing/CGFloat(count+1)))/CGFloat(count+1)
    }
    
    static let imageSize: CGFloat = 20
}
