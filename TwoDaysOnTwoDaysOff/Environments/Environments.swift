//
//  Environments.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 14.10.2021.
//

import UIKit
import SwiftUI

private struct DetailsViewPresentedKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isDetailsViewPresented: Bool {
        get { self[DetailsViewPresentedKey.self] }
        set { self[DetailsViewPresentedKey.self] = newValue }
    }
}
