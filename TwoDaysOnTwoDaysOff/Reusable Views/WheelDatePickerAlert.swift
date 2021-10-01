//
//  WheelDatePickerAlert.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 29.09.2021.
//

import SwiftUI

struct WheelDatePickerAlert: View {
    @Binding var isPresented: Bool
    @Binding var selection: Date
    
    @State private var yPoint: CGFloat = UIScreen.main.bounds.height
    @State private var scaleEffect: CGFloat = 0
    @State private var opacity: Double = 1
    
    var range: ClosedRange<Date>
    
    var body: some View {
        VStack {
            DatePicker(
                "",
                selection: $selection,
                in: range,
                displayedComponents: .date
            )
            .datePickerStyle(WheelDatePickerStyle())
            .environment(\.locale, Locale(identifier: "ru_RU"))
            Divider()
            HStack {
                Button {
                    self.isPresented = false
                } label: {
                    Text("Accept")
                        .foregroundColor(Color(UserSettings.restDayCellColor!))
                        .bold()
                }
                .padding(.vertical, 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(.white))
        )
        .scaleEffect(scaleEffect)
        .offset(y: yPoint)
        .padding()
        .onChange(of: isPresented) { value in
            if value {
                self.show()
            } else {
                self.hide()
            }
        }
    }
    
    private func show() {
        let workItem = DispatchWorkItem {
            self.yPoint = 0
        }
        workItem.perform()
        workItem.notify(queue: DispatchQueue.main) {
            withAnimation(.easeOut) {
                self.scaleEffect = 1
            }
        }
        workItem.cancel()
    }
    
    private func hide() {
        let workItem = DispatchWorkItem {
            withAnimation(.easeIn){
                self.scaleEffect = 0
            }
        }
        workItem.perform()
        workItem.notify(queue: DispatchQueue.main) {
            self.yPoint = UIScreen.main.bounds.height
        }
        workItem.cancel()
    }
}

struct WheelDatePickerAlert_Previews: PreviewProvider {
    static var previews: some View {
        WheelDatePickerAlert(isPresented: .constant(true), selection: .constant(Date()), range: Date()...Date())
    }
}
