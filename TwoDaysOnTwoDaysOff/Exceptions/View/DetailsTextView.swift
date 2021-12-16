//
//  DetailsTextView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 13.12.2021.
//

import SwiftUI
import Combine

struct DetailsTextView: View {
    @Binding var selection: String
    @ObservedObject private var keyboardObserver = KeyboardObserver()
    var body: some View {
        TextView(selection: $selection) { view in
            view.isScrollEnabled = true
            view.isEditable = true
            view.isUserInteractionEnabled = true
            view.autocapitalizationType = .sentences
            view.autocorrectionType = .default
            view.font = view.font?.withSize(18)
        }
        .padding(.horizontal, LayoutConstants.perfectPadding(16))
        .padding(.bottom, LayoutConstants.perfectPadding(16) + keyboardObserver.keyboardFrame.height)
        .navigationBarItems(trailing: clearButton)
        .navigationBarTitle(Text(selection.count.description + "/" + "400"), displayMode: .inline)
        .onReceive(Just(selection)) { _ in
            if selection.count > 400 {
                selection = String(selection.prefix(400))
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var clearButton: some View {
        Button("Clear") {
            selection = ""
        }
        .foregroundColor(selection.isEmpty ? Color.secondary : Color(UserSettings.restDayCellColor!))
        .disabled(selection.isEmpty)
    }
}

struct DetailsTextView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsTextView(selection: .constant(""))
    }
}
