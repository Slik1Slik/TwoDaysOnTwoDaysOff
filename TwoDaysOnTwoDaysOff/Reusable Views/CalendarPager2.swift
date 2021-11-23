//
//  CalendarPager2.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.11.2021.
//

import Foundation
import SwiftUI

struct CalendarPager2<Content: View>: View {
    let screen = UIScreen.main.bounds.size
    
    @State private var yPoint: CGFloat = 0
    @State private var opacity: Double = 1
    @Binding var selection: Int
    @State private var scrollDirection = ScrollDirection.forward
    @State private var swipeType = SwipeType.short
    @State private var isGestureActive = false
    @State private var isDisabled = false
    
    private var isCurrentPageFirst: Bool {
        selection == 0
    }
    private var isCurrentPageLast: Bool {
        selection == pages.count - 1
    }
    
    private let sufficientGestureHeight: CGFloat = UIScreen.main.bounds.size.height / 3
    
    @GestureState private var gestureState: DragGestureState = .inactive
    
    var pages: [Content]
    
    var body: some View {
        VStack {
            pages[selection]
                .opacity(opacity)
        }
        .offset(y: isGestureActive ? yPoint : 0)
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    isGestureActive = true
                    withAnimation {
                        let isTranslationHeightSufficient = value.translation.height > sufficientGestureHeight
                        self.yPoint = isTranslationHeightSufficient ? sufficientGestureHeight : value.translation.height
                        if value.translation.height < 0 {
                            scrollDirection = .forward
                        } else {
                            scrollDirection = .back
                        }
                        changeOpacity(yPoint: yPoint)
                    }
                }
                .onEnded { value in
                    if value.predictedEndTranslation.height < -sufficientGestureHeight || value.predictedEndTranslation.height > sufficientGestureHeight
                    {
                        opacity = 0
                        swipeType = .sufficient
                    } else {
                        swipeType = .short
                    }
                    if swipeType == .sufficient {
                        if scrollDirection == .forward && !isCurrentPageLast {
                            selection += 1
                        }
                        if scrollDirection == .back && !isCurrentPageFirst {
                            selection -= 1
                        }
                    } else {
                        withAnimation {
                            yPoint = 0
                        }
                    }
                    withAnimation {
                        isGestureActive = false
                        yPoint = 0
                        changeOpacity(yPoint: yPoint)
                    }
                })
    }
    
    private func yPointsRanges() -> Array<ClosedRange<Int>> {
        let interval = Int(sufficientGestureHeight/10)
        var result: Array<ClosedRange<Int>> = []
        var lowerBound = 0
        var upperBound = interval
        for _ in 0...9 {
            result.append(lowerBound...upperBound)
            lowerBound = upperBound
            upperBound += interval
        }
        return result.reversed()
    }
    
    private func changeOpacity(yPoint: CGFloat) {
//        guard !((isCurrentPageFirst && scrollDirection == .back) || (isCurrentPageLast && scrollDirection == .forward)) else {
//            opacity = 1
//            return
//        }
        guard yPoint != 0 else {
            opacity = 1
            return
        }
        let yPointsRanges = yPointsRanges()
        for rangeIndex in 0..<yPointsRanges.count {
            if yPointsRanges[rangeIndex].contains(Int(abs(yPoint))) {
                opacity = Double(rangeIndex)/10/2
            }
        }
    }
    private func change(yPoint: CGFloat) {
        
    }
}
extension CalendarPager2 {
    private enum ScrollDirection {
        case forward
        case back
    }
}

extension CalendarPager2 {
    private enum SwipeType {
        case short
        case sufficient
    }
}

extension CalendarPager2 {
    private enum DragGestureState {
        case active
        case inactive
        case dragging(value: DragGesture.Value)
        
        var value: DragGesture.Value? {
            switch self {
            case .inactive, .active:
                return nil
            case .dragging(let value):
                return value
            }
        }
        
        var isActive: Bool {
            switch self {
            case .active, .dragging:
                return true
            case .inactive:
                return false
            }
        }
    }
}
