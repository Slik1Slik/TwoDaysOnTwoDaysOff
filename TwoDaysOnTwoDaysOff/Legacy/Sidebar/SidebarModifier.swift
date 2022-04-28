//
//  SidebarModifier.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 02.02.2022.
//

import SwiftUI
import UIKit

struct SidebarModifier<Sidebar: View>: ViewModifier {
    @Binding var isBarPresented: Bool
    var style: SidebarStyle
    var sidebar: () -> Sidebar
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    private let maxBarXPointValue: CGFloat
    private let minBarXPointValue: CGFloat
    
    @State private var barXPoint: CGFloat
    @State private var contentXPoint: CGFloat = 0
    
    @State private var contentSwipeType = SwipeType.short
    @State private var barSwipeType = SwipeType.short
    @State private var swipeDirection: ScrollDirection = .forward
    
    private let slideAnimation: Animation = .easeOut(duration: 0.2)
    
    func body(content: Content) -> some View {
        content
            .frame(width: screenWidth)
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        guard value.startLocation.x < 25.5,
                              value.translation.width > 0,
                              value.startLocation.y > LayoutConstants.window.frame.maxY - LayoutConstants.safeFrame.maxY
                        else {
                            return
                        }
                        contentSwipeType = (value.translation.width >= abs(screenWidth / 3)) ? .sufficient : .short
                        withAnimation(slideAnimation) {
                            isBarPresented = contentSwipeType == .sufficient
                        }
                    },
                including: .all
            )
            .disabled(isBarPresented)
            .offset(x: isBarPresented ? style.size : 0)
            .overlay(sidebarPlaceholder)
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    guard value.translation.width < 0,
                          isBarPresented
                    else {
                        return
                    }
                    contentSwipeType = (abs(value.translation.width) >= style.size / 3) ? .sufficient : .short
                    withAnimation(slideAnimation) {
                        isBarPresented = contentSwipeType == .short
                    }
                }
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    let contentAreaXRange = (maxBarXPointValue + style.size)...screenWidth
                    guard contentAreaXRange.contains(value.startLocation.x) else {
                        return
                    }
                    withAnimation(slideAnimation) {
                        isBarPresented = false
                    }
                }
        )
    }
    
    init(isBarPresented: Binding<Bool>, style: SidebarStyle, sidebar: @escaping () -> Sidebar) {
        self._isBarPresented = isBarPresented
        self.style = style
        self.sidebar = sidebar
        
        self.maxBarXPointValue = style.size/2-screenWidth/2
        self.minBarXPointValue = -style.size/2-screenWidth/2
        
        self.barXPoint = minBarXPointValue
    }
    
    private var sidebarPlaceholder: some View {
        sidebar()
            .frame(width: style.size)
            .offset(x: isBarPresented ? maxBarXPointValue : minBarXPointValue)
    }
}

enum SidebarStyle {
    case small
    case regular
    case large
    case extraLarge
    
    fileprivate var size: CGFloat {
        switch self {
        case .small: return UIScreen.main.bounds.width / 2
        case .regular: return UIScreen.main.bounds.width / 3 * 2
        case .large: return UIScreen.main.bounds.width / 4 * 3
        case .extraLarge: return UIScreen.main.bounds.width / 5 * 4
        }
    }
}

enum SidebarContentAnimation {
    case none
    case offset
    case brightness
}

extension View {
    func sidebar<Content: View>(isBarPresented: Binding<Bool>, style: SidebarStyle, sidebar: @escaping () -> Content) -> some View {
        return self.modifier(SidebarModifier(isBarPresented: isBarPresented, style: style, sidebar: sidebar))
    }
}
