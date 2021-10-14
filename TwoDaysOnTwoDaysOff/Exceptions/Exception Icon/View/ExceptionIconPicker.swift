//
//  ExceptionIconPicker.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 10.10.2021.
//

import SwiftUI

struct ExceptionIconPicker: View {
    @Binding var selection: ExceptionIcon
    private var viewModel = ExceptionIconViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                ForEach(viewModel.icons(isWorking: selection.isWorking), id: \.self) { icon in
                    VStack {
                        Image(uiImage: UIImage(data: icon.image) ?? UIImage(named: "exceptionIconPlaceholder")!)
                        Text(icon.label)
                            .font(icon.id == selection.id ? .caption.bold() : .caption)
                            .foregroundColor(icon.id == selection.id ? Color(.link) : Color(.black))
                    }
                    .padding(8)
                    .addBorder(
                        icon.id == selection.id ? Color(.link) : Color(.systemGray5),
                        width: icon.id == selection.id ? 3 : 1,
                        cornerRadius: 8
                    )
                    .onTapGesture {
                        self.selection = icon
                    }
                }
            }
        }
    }
    init(selection: Binding<ExceptionIcon>) {
        self._selection = selection
    }
}

struct ExceptionIconPicker_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionIconPicker(selection: .constant(ExceptionIcon()))
    }
}
