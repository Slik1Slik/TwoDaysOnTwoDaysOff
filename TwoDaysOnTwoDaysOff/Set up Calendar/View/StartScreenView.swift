//
//  StartScreenView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ScreenView<Content: View>: View {
    
    let content: () -> Content
    
    var currentIndex: Int
    var title: String
    var details: String
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectPadding(25)) {
            Text(title)
                .font(.title)
                .multilineTextAlignment(.center)
            content()
            Text(details)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding(LayoutConstants.perfectPadding(16))
        Spacer()
    }
    
    init(currentIndex: Int, title: String, details: String, @ViewBuilder content: @escaping () -> Content) {
        self.currentIndex = currentIndex
        self.title = title
        self.details = details
        self.content = content
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView(currentIndex: 0, title: "", details: "") {
            DaysColorsView(.reversed) { _ in
                
            }
        }
    }
}
