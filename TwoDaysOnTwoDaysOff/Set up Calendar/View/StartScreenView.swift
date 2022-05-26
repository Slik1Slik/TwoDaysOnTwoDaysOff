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
        VStack(spacing: LayoutConstants.perfectValueForCurrentDeviceScreen(25)) {
            Text(title)
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            content()
            Text(details)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, LayoutConstants.perfectValueForCurrentDeviceScreen(16))
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
            
        }
    }
}
