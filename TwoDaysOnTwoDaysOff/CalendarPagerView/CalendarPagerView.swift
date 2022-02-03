//
//  CalendarPagerView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.11.2021.
//

import Foundation
import SwiftUI

struct CalendarPagerView<Content: View>: View {
    let screen = UIScreen.main.bounds.size
    
    @State private var yPoint: CGFloat = 0
    @State private var opacity: Double = 1
    @Binding var selection: Int
    @State private var scrollDirection = ScrollDirection.forward
    @State private var swipeType = SwipeType.short
    @State private var isGestureActive = false
    
    @ObservedObject private var keyboardObserver = KeyboardObserver()
    
    private var isCurrentPageFirst: Bool {
        selection == 0
    }
    private var isCurrentPageLast: Bool {
        selection == pages.count - 1
    }
    
    private let sufficientGestureHeight: CGFloat = UIScreen.main.bounds.size.height / 4
    
    private let safeFrame = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
    
    var pages: [Content]
    
    var body: some View {
        VStack {
            pages[selection]
        }
        //.opacity(opacity)
        .disabled(isGestureActive)
        .offset(y: isGestureActive ? yPoint : 0)
        .contentShape(Rectangle())
        .onTapGesture {
            isGestureActive = false
            yPoint = 0
        }
        .gesture(
            DragGesture()
                .onChanged { value in
//                    print("height: " + value.translation.height.description)
//                    print("width: " + value.translation.width.description)
                    guard safeFrame.contains(value.startLocation),
                          value.startLocation.x > 40,
                          value.startLocation.x < UIScreen.main.bounds.maxX - 40
                    else {
                        return
                    }
                    isGestureActive = true
                    withAnimation {
                        if value.translation.height < 0 {
                            scrollDirection = .forward
                        } else {
                            scrollDirection = .back
                        }
                        let isTranslationHeightSufficient = abs(value.translation.height) >= sufficientGestureHeight
                        if isTranslationHeightSufficient {
                            self.yPoint = scrollDirection == .forward ? -sufficientGestureHeight : sufficientGestureHeight
                        } else {
                            self.yPoint = value.translation.height
                        }
                    }
                }
                .onEnded { value in
                    guard safeFrame.contains(value.startLocation) else {
                        return
                    }
                    let isCurrentPageLastAndDirectionBack = isCurrentPageLast && scrollDirection == .back
                    let isCurrentPageFirstAndDirectionForward = isCurrentPageFirst && scrollDirection == .forward
                    let isCurrentPageNotFirstOrLast = !(isCurrentPageFirst || isCurrentPageLast)
                    guard isCurrentPageLastAndDirectionBack || isCurrentPageFirstAndDirectionForward || isCurrentPageNotFirstOrLast else {
                        withAnimation {
                            showPage()
                        }
                        return
                    }
                    if value.translation.height < -sufficientGestureHeight || value.translation.height > sufficientGestureHeight
                    {
                        swipeType = .sufficient
                    } else {
                        swipeType = .short
                    }
                    if swipeType == .sufficient {
                        prepareNextPage()
                        changePage()
                        withAnimation(.easeOut(duration: 0.3)) {
                            showPage()
                        }
                    }
                    else {
                        withAnimation {
                            showPage()
                        }
                    }
                })
    }
    
//    private func hideCurrentPage() {
//        if scrollDirection == .forward {
//            yPoint -= screen.height - sufficientGestureHeight
//        }
//        if scrollDirection == .back {
//            yPoint += screen.height + sufficientGestureHeight
//        }
//        opacity = 0
//    }
    
    private func prepareNextPage() {
        if scrollDirection == .forward {
            yPoint += screen.height * 2 + sufficientGestureHeight
        }
        if scrollDirection == .back {
            yPoint -= screen.height * 2 - sufficientGestureHeight
        }
    }
    
    private func changePage() {
        if scrollDirection == .forward {
            selection += 1
        }
        if scrollDirection == .back {
            selection -= 1
        }
        //opacity = 0
    }
    
    private func showPage() {
        //opacity = 1
        isGestureActive = false
        yPoint = 0
    }
    
//    private func yPointsRanges() -> Array<ClosedRange<Int>> {
//        let interval = Int(sufficientGestureHeight/10)
//        var result: Array<ClosedRange<Int>> = []
//        var lowerBound = 0
//        var upperBound = interval
//        for _ in 0...9 {
//            result.append(lowerBound...upperBound)
//            lowerBound = upperBound
//            upperBound += interval
//        }
//        return result.reversed()
//    }
//
//    private func changeOpacity(yPoint: CGFloat) {
//        guard yPoint != 0 else {
//            opacity = 1
//            return
//        }
//        let yPointsRanges = yPointsRanges()
//        for rangeIndex in 0..<yPointsRanges.count {
//            if yPointsRanges[rangeIndex].contains(Int(abs(yPoint))) {
//                opacity = Double(rangeIndex + 1)/10
//            }
//        }
//    }
}

struct CalendarPagerViewTracker: ViewModifier {
    var onPageMoving: () -> () = { }
    var onPageStopMoving: () -> () = { }
    
    @State private var interval: TimeInterval = TimeInterval(0.0)
    @State private var timer: Timer = Timer()
    
    func body(content: Content) -> some View {
        timer = Timer(timeInterval: 0.1, repeats: true, block: { timer in
            interval += timer.timeInterval
        })
        return content
            .simultaneousGesture(
                DragGesture()
                    .onChanged({ _ in
                        timer.fire()
                        onPageMoving()
                    })
                    .onEnded({ _ in
                        
                    })
            )
    }
}

extension CalendarPagerView {
    func onPageMoving(_ action: @escaping ()->()) -> some View {
        return self.modifier(CalendarPagerViewTracker(onPageMoving: action, onPageStopMoving: {}))
    }
    func onPageStopMoving(_ action: @escaping ()->()) -> some View {
        return self.modifier(CalendarPagerViewTracker(onPageMoving: {}, onPageStopMoving: action))
    }
    func pageMovingTracker(onMoving: @escaping ()->() = {}, onStopMoving: @escaping ()->() = {}) -> some View {
        return self.modifier(CalendarPagerViewTracker(onPageMoving: onMoving, onPageStopMoving: onStopMoving))
    }
}

extension CalendarPagerView {
    private enum ScrollDirection {
        case forward
        case back
    }
}

extension CalendarPagerView {
    private enum SwipeType {
        case short
        case sufficient
    }
}
