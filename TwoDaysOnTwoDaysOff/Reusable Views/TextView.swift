//
//  TextView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 14.10.2021.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var selection: String
    var configuration = { (view: UIViewType) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
        uiView.text = selection
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($selection)
    }
     
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
     
        init(_ text: Binding<String>) {
            self.text = text
        }
     
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(selection: .constant(""))
    }
}
