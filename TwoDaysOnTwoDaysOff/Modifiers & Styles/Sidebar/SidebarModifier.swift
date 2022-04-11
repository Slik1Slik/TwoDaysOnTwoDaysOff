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
    var type: SidebarType
    var sidebar: () -> Sidebar
    
    var animation: SidebarContentAnimation = .none
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    private let maxBarXPointValue: CGFloat
    private let minBarXPointValue: CGFloat
    
    @State private var barXPoint: CGFloat
    @State private var contentXPoint: CGFloat = 0
    
    @State private var contentSwipeType = SwipeType.short
    @State private var barSwipeType = SwipeType.short
    @State private var swipeDirection: ScrollDirection = .forward
    
    @State private var contentBrightness: Double = 0
    
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
            .offset(x: isBarPresented ? type.size : 0)
            .overlay(sidebarPlaceholder)
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    guard value.translation.width < 0,
                          isBarPresented
                    else {
                        return
                    }
                    contentSwipeType = (abs(value.translation.width) >= type.size / 3) ? .sufficient : .short
                    withAnimation(slideAnimation) {
                        isBarPresented = contentSwipeType == .short
                    }
                }
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    let contentAreaXRange = (maxBarXPointValue + type.size)...screenWidth
                    guard contentAreaXRange.contains(value.startLocation.x) else {
                        return
                    }
                    withAnimation(slideAnimation) {
                        isBarPresented = false
                    }
                }
        )
    }
    
    init(isBarPresented: Binding<Bool>, type: SidebarType, sidebar: @escaping () -> Sidebar) {
        self._isBarPresented = isBarPresented
        self.type = type
        self.sidebar = sidebar
        
        self.maxBarXPointValue = type.size/2-screenWidth/2
        self.minBarXPointValue = -type.size/2-screenWidth/2
        
        self.barXPoint = minBarXPointValue
    }
    
    private var sidebarPlaceholder: some View {
        sidebar()
            .frame(width: type.size)
            .offset(x: isBarPresented ? maxBarXPointValue : minBarXPointValue)
    }
    
//    private func animateContent() {
//        switch animation {
//        case .none:
//            break
//        case .offset:
//            executeOffsetContentAnimation()
//        case .brightness:
//            executeBrightnessContentAnimation()
//        }
//    }
    
    private func executeOffsetContentAnimation() {
        
    }
    
    private func executeBrightnessContentAnimation(currentXPoint: CGFloat, newXPoint: CGFloat) {
        let brightnessIncrement = maxBarXPointValue / 50
        let direction: ScrollDirection = currentXPoint < newXPoint ? .forward : .back
        if abs(currentXPoint - newXPoint) > brightnessIncrement {
            contentBrightness += direction == .forward ? -0.01 : 0.01
        }
    }
}

enum SidebarType {
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
    func sidebar<Content: View>(isBarPresented: Binding<Bool>, type: SidebarType, sidebar: @escaping () -> Content) -> some View {
        return self.modifier(SidebarModifier(isBarPresented: isBarPresented, type: type, sidebar: sidebar))
    }
}

//MARK: Prevent pushing content

//GeometryReader { _ in
//    ZStack {
//    }
//}
//.ignoresSafeArea(.keyboard, edges: .bottom)
