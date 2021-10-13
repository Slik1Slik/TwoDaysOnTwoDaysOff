//
//  ExceptionIconPicker.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 10.10.2021.
//

import SwiftUI

struct ExceptionIconPicker: View {
    @Binding var selection: ExceptionIcon
    @ObservedObject private var viewModel = ExceptionIconViewModel()
    @State var isWorking = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                ForEach(viewModel.icons(isWorking: isWorking), id: \.self) { icon in
                    VStack {
                        Image(uiImage: UIImage(data: icon.image) ?? UIImage(named: "exceptionIconPlaceholder")!)
                        Text(icon.label)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(lineWidth: icon.id == selection.id ? 3 : 1)
                            .foregroundColor(icon.id == selection.id ? Color(.systemGray5) : Color(.link))
                            .padding()
                    )
                    .onTapGesture {
                        self.selection = icon
                    }
                }
            }
        }
    }
}

struct ExceptionIconPicker_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionIconPicker(selection: .constant(ExceptionIcon()))
    }
}
