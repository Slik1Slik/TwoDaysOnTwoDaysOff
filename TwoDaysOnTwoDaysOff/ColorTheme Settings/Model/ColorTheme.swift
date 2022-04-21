//
//  ColorPalette.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 17.04.2022.
//

import SwiftUI

struct ColorTheme: Codable, Hashable {
    
    var id: String
    
    var name: String
    
    var accent: HSBAComponents
    
    var workingDayText: HSBAComponents
    var restDayText: HSBAComponents
    
    var workingDayBackground: HSBAComponents
    var restDayBackground: HSBAComponents
    
    init() {
        
        id = UUID().uuidString
        
        name = ""
        
        self.accent = UIColor.link.hsbaComponents
        self.restDayText = UIColor.black.hsbaComponents
        self.workingDayText = UIColor.white.hsbaComponents
        self.restDayBackground = UIColor.white.hsbaComponents
        self.workingDayBackground = Color.black.opacity(0.8).uiColor.hsbaComponents
    }
}
