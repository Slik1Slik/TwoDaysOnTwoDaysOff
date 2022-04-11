//
//  Environments.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 14.10.2021.
//

import UIKit
import SwiftUI

private struct ApplicationColorPaletteKey: EnvironmentKey {
    static let defaultValue: ColorPalette = MonochromeColorPalette()
}

extension EnvironmentValues {
    var colorPalette: ColorPalette {
        get { self[ApplicationColorPaletteKey.self] }
        set { self[ApplicationColorPaletteKey.self] = newValue }
    }
}
