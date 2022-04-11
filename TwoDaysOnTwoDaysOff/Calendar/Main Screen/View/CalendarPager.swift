//
//  CalendarPagerViewV2.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.02.2022.
//

import SwiftUI

struct CalendarPager<Content: View>: View {
    private let screen = UIScreen.main.bounds.size
    
    @State private var yPoint: CGFloat = 0
    @State private var scrollDirection = ScrollDirection.forward
    @State private var swipeType = SwipeType.short
    @State private var isGestureActive = false
    
    private var isCurrentPageFirst: Bool {
        selection == 0
    }
    private var isCurrentPageLast: Bool {
        selection == pages.count - 1
    }
    
    private let sufficientGestureHeight: CGFloat = UIScreen.main.bounds.size.height / 4
    
    private let safeFrame = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
    
    @Binding var selection: Int
    var pages: [Content]
    
    var onPageMove: () -> () = {}
    var onPageStopMove: () -> () = {}
    var onPageChanged: () -> () = {}
    
    var body: some View {
        VStack {
            pages[selection]
        }
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
                    guard safeFrame.contains(value.startLocation),
                          value.startLocation.x > 40,
                          value.startLocation.x < UIScreen.main.bounds.maxX - 40
                    else {
                        return
                    }
                    if isGestureActive != true {
                        isGestureActive = true
                    }
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
                    guard safeFrame.contains(value.startLocation),
                          value.startLocation.x > 40,
                          value.startLocation.x < UIScreen.main.bounds.maxX - 40
                    else {
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
                        changePage()
                        prepareNextPage()
                        withAnimation(.easeOut(duration: 0.3)) {
                            showPage()
                        }
                    }
                    else {
                        withAnimation {
                            showPage()
                        }
                    }
                    onPageStopMove()
                })
    }
    
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
    }
    
    private func showPage() {
        isGestureActive = false
        yPoint = 0
    }
}
