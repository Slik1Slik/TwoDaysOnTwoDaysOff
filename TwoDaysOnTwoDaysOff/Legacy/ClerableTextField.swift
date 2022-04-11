//
//  ClerableTextField.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 27.03.2022.
//

import SwiftUI

struct ClerableTextField: View {
    var titleKey: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField(titleKey, text: $text)
            if !text.isEmpty {
                withAnimation {
                    clearTextButton
                }
            }
        }
    }
    
    @ViewBuilder
    private var clearTextButton: some View {
        Button {
            text.removeAll()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        ClerableTextField(titleKey: "", text: .constant(""))
    }
}
