//
//  AvailabilityModifier.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 24.04.2022.
//

import SwiftUI

struct Availability<Content> {
    let content: Content
}

extension Availability where Content: View {
    @ViewBuilder func tint(_ color: Color) -> some View {
        if #available(iOS 15, *) {
            content.tint(color)
        } else {
            content.accentColor(color)
        }
    }
}
