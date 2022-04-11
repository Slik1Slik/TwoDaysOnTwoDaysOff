//
//  DetailsViewMode.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 08.04.2022.
//

import SwiftUI

enum DetailsViewMode {
    case add
    case update
}

private struct DetailsViewModeKey: EnvironmentKey {
    static let defaultValue: DetailsViewMode = .add
}

extension EnvironmentValues {
    var detailsViewMode: DetailsViewMode {
        get { self[DetailsViewModeKey.self] }
        set { self[DetailsViewModeKey.self] = newValue }
    }
}
