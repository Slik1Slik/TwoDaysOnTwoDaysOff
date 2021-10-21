//
//  Environments.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 14.10.2021.
//

import UIKit
import SwiftUI

private struct AlertPresentedKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isAlertPresented: Bool {
        get { self[AlertPresentedKey.self] }
        set { self[AlertPresentedKey.self] = newValue }
    }
}

extension View {
    func isAlertPresented(_ isPresented: Bool) -> some View {
        environment(\.isAlertPresented, isPresented)
    }
}
