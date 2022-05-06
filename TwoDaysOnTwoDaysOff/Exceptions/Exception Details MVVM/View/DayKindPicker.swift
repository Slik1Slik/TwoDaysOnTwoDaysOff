//
//  DayKindPicker.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 25.04.2022.
//

import SwiftUI

struct DayKindPicker: View {
    
    @Binding var selection: Bool
    
    @State private var dayKind: DayKind
    
    @Environment(\.colorPalette) private var colorPalette
    
    var body: some View {
        VStack {
            row(dayKind: .dayOff)
            Divider()
                .padding(.trailing, -LayoutConstants.perfectValueForCurrentDeviceScreen(16))
            row(dayKind: .working)
        }
        .onChange(of: dayKind) { kind in
            selection = kind == .working
        }
    }
    
    private func row(dayKind: DayKind) -> some View {
        Button {
            self.dayKind = dayKind
        } label: {
            HStack {
                Text(dayKind.rawValue)
                    .foregroundColor(colorPalette.textPrimary)
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(dayKind == self.dayKind ? colorPalette.buttonPrimary : .clear)
                    .animation(.none)
            }
        }
    }
    
    init(selection: Binding<Bool>) {
        self._selection = selection
        self.dayKind = selection.wrappedValue ? .working : .dayOff
    }
    
    enum DayKind: String, CaseIterable {
        case working = "Рабочий"
        case dayOff = "Выходной"
    }
}
