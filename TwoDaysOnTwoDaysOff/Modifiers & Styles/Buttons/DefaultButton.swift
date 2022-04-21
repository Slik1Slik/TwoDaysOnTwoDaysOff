//
//  Buttons.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 16.12.2021.
//

import Foundation
import SwiftUI

struct DefaultButton: ButtonStyle {
    var isHighlighted = false
    var colorPalette: ColorPalette
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(isHighlighted ? colorPalette.buttonPrimary : .clear)
            .cornerRadius(8)
            .foregroundColor(isHighlighted ? colorPalette.highlighted : colorPalette.buttonPrimary)
            .font(.title2)
    }
}

struct HighlightedDefaultButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(ApplicationColorPalette.shared.buttonPrimary)
            .cornerRadius(8)
            .foregroundColor(ApplicationColorPalette.shared.highlighted)
            .font(.title2)
    }
}
