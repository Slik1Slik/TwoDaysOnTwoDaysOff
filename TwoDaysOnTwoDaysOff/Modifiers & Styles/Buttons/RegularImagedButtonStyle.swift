//
//  Buttons.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 16.12.2021.
//

import Foundation
import SwiftUI

struct RegularImagedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .foregroundColor(Color(UserSettings.restDayCellColor!))
                .font(.title3)
                .background(.quaternary, in: Capsule())
        } else {
            configuration.label
                .foregroundColor(Color(UserSettings.restDayCellColor!))
                .font(.title3)
        }
    }
}

struct MyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: { print("Pressed") }) {
            Label("Press Me", systemImage: "star")
        }
        .buttonStyle(RegularImagedButtonStyle())
    }
}
