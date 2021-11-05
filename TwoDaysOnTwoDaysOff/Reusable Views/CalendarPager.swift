//
//  CalendarPager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 13.07.2021.
//

import SwiftUI
import Combine

struct CalendarPager<Content: View>: View {
    let screen = UIScreen.main.bounds.size
    @ObservedObject var applicationObserver = ApplicationObserver()
    
    @State private var yPoint: CGFloat = UIScreen.main.bounds.size.height
    @State private var previousYPoint: CGFloat = UIScreen.main.bounds.size.height
    @Binding var selection: Int
    @State private var scrollDirection = ScrollDirection.forward
    @State private var swipeType = SwipeType.short
    @State private var isGestureActive = false
    @GestureState private var gestureState: DragGestureState = .inactive
    @State private var isDisabled = false
    //@State var gestureValue: DragGesture.Value?
    
    var pages: [Content]
    
    var body: some View {
        VStack {
            ForEach(0..<pages.count) { page in
                pages[page]
            }
        }
        .offset(y: gestureState.isActive ? yPoint : turnedPageYPoint())
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture()
                .updating($gestureState, body: { value, state, transaction in
                    guard transaction.isContinuous else {
                        state = .inactive
                        return
                    }
                    state = .dragging(value: value)
                })
                .onChanged { value in
                    isGestureActive = true
                    guard applicationObserver.appIsActive else {
                        return
                    }
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
        .disabled(isDisabled)
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

extension CalendarPager {
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
//    private func gestureStartsInBottomSafeArea() -> Bool {
//        guard let yPoint = gestureValue?.startLocation.y else {
//            return false
//        }
//        let isCurrentPageFirst = self.selection == pages.count / 2 || self.selection == pages.count / 2 + 1 || self.selection == pages.count / 2 - 1
//        let lowestYPoint = screen.height / 2
//        let window = UIApplication.shared.windows.first!
//        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
//        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
//        let safeAreaSpaceBottom = lowestYPoint..<lowestYPoint + bottomSafeAreaHeight
//        return safeAreaSpaceBottom.contains(isCurrentPageFirst ? yPoint : yPoint / screen.height)
//    }
//
//    private func gestureStartsInTopSafeArea(y: CGFloat) -> Bool {
//        let highestYPoint = UIScreen.main.bounds.height
//        let window = UIApplication.shared.windows.first!
//        let topSafeAreaHeight = window.frame.minY
//        let safeAreaSpaceTop = highestYPoint..<highestYPoint + topSafeAreaHeight
//        return safeAreaSpaceTop.contains(y)
//    }
}
