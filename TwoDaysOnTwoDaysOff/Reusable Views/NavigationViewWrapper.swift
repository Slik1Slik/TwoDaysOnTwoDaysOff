//
//  NavigationViewWrapper.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.04.2022.
//

import SwiftUI

struct NavigationViewWrapper<Content: View, BarItem: View>: View {
    
    var title: Text
    
    var leadingItem: (Content: BarItem, DismissOnTap: Bool)?
    var trailingItem: (Content: BarItem, DismissOnTap: Bool)?
    
    var content: () -> Content
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
                .padding(LayoutConstants.perfectValueForCurrentDeviceScreen(16))
            content()
                .environment(\.colorPalette, colorPalette)
        }
    }
    
    private var navigationBar: some View {
        title
            .frame(maxWidth: .infinity, alignment: .center)
            .ifAvailable.overlay {
                HStack{
                    if let leadingItem = leadingItem {
                        leadingItem.Content
                            .foregroundColor(colorPalette.buttonPrimary)
                            .font(.title2)
                            .simultaneousGesture(
                                tapGesture(dismisses: leadingItem.DismissOnTap)
                            )
                    }
                    Spacer()
                    if let trailingItem = trailingItem {
                        trailingItem.Content
                            .foregroundColor(colorPalette.buttonPrimary)
                            .font(.title2)
                            .simultaneousGesture(
                                tapGesture(dismisses: trailingItem.DismissOnTap)
                            )
                    }
                }
            }
    }
    
    private func tapGesture(dismisses: Bool) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                if dismisses {
                    if #available(iOS 15, *) {
                        EnvironmentValues().dismiss()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
}

