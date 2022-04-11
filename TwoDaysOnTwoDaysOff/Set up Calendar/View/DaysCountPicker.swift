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
        GeometryReader { geometry in
            HStack {
                Picker("", selection: $workingDays) {
                    ForEach(0..<30) {
                        Text(($0+1).description).tag($0+1)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: geometry.size.width / 2 - 10, height: geometry.size.height * 0.5)
                .clipped()
                
                Divider()
                
                Picker("", selection: $restDays) {
                    ForEach(0..<30) {
                        Text(($0+1).description).tag($0+1)
                    }
                }
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: geometry.size.width / 2 - 10, height: geometry.size.height * 0.5)
                .clipped()
            }
        }
    }
}

struct DaysCountPicker_Previews: PreviewProvider {
    static var previews: some View {
        DaysCountPicker(workingDays: .constant(2), restDays: .constant(2))
    }
}
