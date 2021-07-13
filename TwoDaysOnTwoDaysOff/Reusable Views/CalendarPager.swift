//
//  CalendarPager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 13.07.2021.
//

import SwiftUI

import SwiftUI

struct CalendarPager<Content: View>: View {
    let screen = UIScreen.main.bounds.size
    @State private var yPoint: CGFloat = UIScreen.main.bounds.size.height
    @State private var previousYPoint: CGFloat = UIScreen.main.bounds.size.height
    @Binding var selection: Int
    @State private var scrollDirection = ScrollDirection.forward
    @State private var swipeType = SwipeType.short
    @State private var isGestureActive = false
    
    var pages: [Content]
    
    var body: some View {
        VStack {
            ForEach(0..<pages.count) { page in
                pages[page]
            }
        }
        .offset(y: isGestureActive ? yPoint : turnedPageYPoint())
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    isGestureActive = true
            withAnimation {
                self.yPoint = turnedPageYPoint() + value.translation.height
                if value.translation.height < 0 {
                    scrollDirection = .forward
                } else {
                    scrollDirection = .back
                }
            }
        }
                .onEnded { value in
            withAnimation {
                isGestureActive = false
                if value.predictedEndTranslation.height < -screen.height/3 || value.predictedEndTranslation.height > screen.height/3
                {
                    swipeType = .sufficient
                } else {
                    swipeType = .short
                }
                if swipeType == .sufficient {
                    if scrollDirection == .forward {
                        if selection < pages.count - 1 {
                            selection += 1
                        } else {
                            selection = pages.count - 1
                        }
                    }
                    if scrollDirection == .back {
                        if selection > 0 {
                            selection -= 1
                        } else {
                            selection = 0
                        }
                    }
                } else {
                    selection = selection
                }
                yPoint = turnedPageYPoint()
            }
        })
        .onAppear {
            self.yPoint = firstPageYPoint() - CGFloat(selection) * screen.height
            self.previousYPoint = self.yPoint
        }
        .onChange(of: selection) { value in
            if value == 0 {
                yPoint = turnedPageYPoint()
            }
        }
    }
    private func turnedPageYPoint() -> CGFloat {
        return firstPageYPoint() - CGFloat(selection) * screen.height
    }
}
extension CalendarPager {
    private func nearestMultiple(from firstNumber: CGFloat, to secondNumber: CGFloat) -> CGFloat {
        var result = abs(firstNumber.rounded())
        var cleanFirstNumber = result
        var cleanFirstNumber2 = result
        
        while cleanFirstNumber.truncatingRemainder(dividingBy: secondNumber) != 0 {
            cleanFirstNumber += 1
        }
        while cleanFirstNumber2.truncatingRemainder(dividingBy: secondNumber) != 0 {
            cleanFirstNumber2 -= 1
        }
        
        if -(result - cleanFirstNumber) < (result - cleanFirstNumber2) {
            result = cleanFirstNumber
        } else {
            result = cleanFirstNumber2
        }
        
        return result * (firstNumber < 0 ? -1 : 1)
    }
}


extension CalendarPager {
    private func firstPageYPoint() -> CGFloat {
        let result = screen.height * CGFloat(self.pages.count/2)
        return nearestMultiple(from: result, to: screen.height)
    }
}

extension CalendarPager {
    private enum ScrollDirection {
        case forward
        case back
    }
}

extension CalendarPager {
    private enum SwipeType {
        case short
        case sufficient
    }
}
