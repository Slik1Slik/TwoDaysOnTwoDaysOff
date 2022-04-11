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
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(isHighlighted ? ApplicationColorPalette.shared.buttonPrimary : .clear)
            .cornerRadius(8)
            .foregroundColor(isHighlighted ? ApplicationColorPalette.shared.buttonHighlighted : ApplicationColorPalette.shared.buttonPrimary)
            .font(.title2)
    }
}

struct HighlightedDefaultButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(ApplicationColorPalette.shared.buttonPrimary)
            .cornerRadius(8)
            .foregroundColor(ApplicationColorPalette.shared.buttonHighlighted)
            .font(.title2)
    }
}
