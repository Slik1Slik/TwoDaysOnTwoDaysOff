//
//  DaysCountPicker.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct DaysCountPicker: View {
    @Binding var workingDays: Int
    @Binding var restDays: Int
    var body: some View {
        HStack(spacing: LayoutConstants.perfectPadding(40)) {
            NumberPicker(selection: $workingDays, range: 1...30)
            NumberPicker(selection: $restDays, range: 1...30)
        }
    }
}

struct NumberPicker: View {
    
    @Binding var selection: Int
    
    var range: ClosedRange<Int>
    
    @Environment(\.colorPalette) private var colorPalette
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectPadding(16)) {
            increaseSelectionButton(value: 1, iconName: "arrowtriangle.up.fill")
                .opacity(selection < range.upperBound ? 1 : 0)
            selectionLabel
            increaseSelectionButton(value: -1, iconName: "arrowtriangle.down.fill")
                .opacity(selection > range.lowerBound ? 1 : 0)
        }
    }
    
    private var selectionLabel: some View {
        Text(selection.description)
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
}

struct DaysCountPicker_Previews: PreviewProvider {
    static var previews: some View {
        DaysCountPicker(workingDays: .constant(2), restDays: .constant(2))
    }
}
