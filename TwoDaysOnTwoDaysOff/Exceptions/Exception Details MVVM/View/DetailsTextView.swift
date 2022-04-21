//
//  DetailsTextView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 13.12.2021.
//

import SwiftUI
import Combine

struct DetailsTextView: View {
    @Environment(\.colorPalette) var colorPalette
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selection: String
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            Divider()
            TextView(selection: $selection) { view in
                view.font = view.font?.withSize(18)
                view.isScrollEnabled = true
                view.isEditable = true
                view.isUserInteractionEnabled = true
                view.autocapitalizationType = .sentences
                view.autocorrectionType = .default
            }
            .padding(.horizontal, LayoutConstants.perfectPadding(16))
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(Just(selection)) { _ in
                if selection.count > 400 {
                    selection = String(selection.prefix(400))
                }
            }
        }
    }
    
    private var navigationBar: some View {
        Text(selection.count.description + "/" + "400")
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(
                HStack{
                    backButton
                    Spacer()
                    clearButton
                }
            )
            .padding()
        
    }
    
    private var clearButton: some View {
        Button(action: { selection = "" }) {
            Text("Clear")
            .bold()
            .foregroundColor(selection.isEmpty ? colorPalette.inactive : colorPalette.buttonPrimary)
        }
        .disabled(selection.isEmpty)
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(colorPalette.buttonPrimary)
                .font(.title)
        }
    }
}

struct DetailsTextView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsTextView(selection: .constant(""))
    }
}
