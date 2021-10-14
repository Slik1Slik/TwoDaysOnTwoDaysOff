//
//  TextView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 14.10.2021.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    
    var selection: Binding<String>
    var configuration = { (view: UIViewType) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
        uiView.text = selection.wrappedValue
        configuration(uiView)
    }
    
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(selection: .constant(""))
    }
}
