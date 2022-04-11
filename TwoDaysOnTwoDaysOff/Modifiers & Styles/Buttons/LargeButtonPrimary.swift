//
//  LargeImagedButtonStyle.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 16.12.2021.
//

import Foundation
import SwiftUI

struct LargeButtonPrimary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(ApplicationColorPalette.shared.buttonPrimary)
            .font(.title.weight(.thin))
    }
}

struct LargeButtonSecondary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(ApplicationColorPalette.shared.buttonSecondary)
            .font(.title.weight(.thin))
    }
}
