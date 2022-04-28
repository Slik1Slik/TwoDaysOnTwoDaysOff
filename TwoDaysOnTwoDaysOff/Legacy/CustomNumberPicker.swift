//
//  CustomNumberPicker.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 23.04.2022.
//

import SwiftUI

struct CustomNumberPicker: View {
    
    @Binding var selection: Int
    
    var range: ClosedRange<Int>
    
    @State private var selectionText: String
    
    @ObservedObject private var keyboardObserver: KeyboardObserver = KeyboardObserver()
    
    @Environment(\.colorPalette) private var colorPalette
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectPadding(16)) {
            increaseSelectionButton(value: 1, iconName: "arrowtriangle.up.fill")
                .opacity(selection < range.upperBound ? 1 : 0)
            selectionLabel
            increaseSelectionButton(value: -1, iconName: "arrowtriangle.down.fill")
                .opacity(selection > range.lowerBound ? 1 : 0)
        }
        .onChange(of: selectionText) { _ in
            guard !selectionText.isEmpty else {
                return
            }
            let number = Int(selectionText)!
            if number <= 30 {
                selection = number
            } else {
                let firstNumber = Int(selectionText.prefix(1))!
                selectionText = String(selectionText.prefix(firstNumber > 2 ? 1 : 2))
            }
        }
        .onChange(of: selection) { newValue in
            selectionText = newValue.description
        }
        .onChange(of: keyboardObserver.isKeyboardShown) { isShown in
            if !isShown && selectionText.isEmpty {
                selectionText = range.lowerBound.description
            }
        }
    }
    
    private var selectionLabel: some View {
        TextField("", text: $selectionText)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .font(.largeTitle)
            .padding(.vertical, LayoutConstants.perfectPadding(25))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorPalette.backgroundTertiary)
                    .frame(width: 80)
            )
            .frame(width: 80)
    }
    
    private func increaseSelectionButton(value: Int, iconName: String) -> some View {
        Button {
            selection += value
        } label: {
            Image(systemName: iconName)
                .foregroundColor(colorPalette.buttonTertiary)
                .font(.largeTitle)
        }

    }
    
    init(selection: Binding<Int>, range: ClosedRange<Int>) {
        self._selection = selection
        self.range = range
        
        self.selectionText = selection.wrappedValue.description
    }
}
