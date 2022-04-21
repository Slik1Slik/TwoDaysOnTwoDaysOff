//
//  ColorGenerator.swift
//  CustomColorPicker
//
//  Created by Slik on 14.04.2022.
//

import SwiftUI

class ColorGenerator {
    static func generateColors(_ components: RGBAComponents,
                               rIncrement: CGFloat = 0,
                               gIncrement: CGFloat = 0,
                               bIncrement: CGFloat = 0,
                               count: Int = 1) -> [Color]
    {
        var rValue = components.red
        var gValue = components.green
        var bValue = components.blue
        
        var resultArray = [Color(red: rValue, green: gValue, blue: bValue)]
        
        for _ in 0..<count {
            rValue += rIncrement
            gValue += gIncrement
            bValue += bIncrement
            
            resultArray.append(Color(red: rValue, green: gValue, blue: bValue))
        }
        
        return resultArray
    }
}
