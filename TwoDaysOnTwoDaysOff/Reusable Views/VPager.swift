//
//  VPager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct VPager<Content: View>: View {
    let screen = UIScreen.main.bounds.size
    @State private var yPoint: CGFloat = UIScreen.main.bounds.size.height
    @State private var previousYPoint: CGFloat = UIScreen.main.bounds.size.height
    @State private var countOfVisiblePages = 3
    @State private var scrollDirection = ScrollDirection.forward
    @Binding var selection: Int
    
    var pages: [Content]
    
    var body: some View {
        VStack {
            ForEach(0..<pages.count) { page in
                pages[page]
            }
        }
        .offset(y: yPoint)
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
            withAnimation {
                if value.translation.height < 0 {
                    self.yPoint -= 4
                    self.scrollDirection = .forward
                } else {
                    self.yPoint += 4
                    self.scrollDirection = .back
                }
            }
        }
                .onEnded { value in
            withAnimation {
                if value.predictedEndTranslation.height > screen.height || value.predictedEndTranslation.height < -screen.height {
                    self.yPoint += scrollDirection == .forward ? -screen.height : screen.height
                } else {
                    self.yPoint += value.predictedEndTranslation.height
                }
            }
            if yPoint.truncatingRemainder(dividingBy: screen.height) != 0 {
                withAnimation {
                    let nearestMultipleNumber = nearestMultiple(from: yPoint, to: screen.height)
                    let firstPagePosition = firstPageOffset()
                    let lastPagePosition = lastPageOffset()
                    
                    if nearestMultipleNumber <= firstPagePosition && nearestMultipleNumber >= lastPagePosition {
                        yPoint = nearestMultipleNumber
                    } else {
                        if nearestMultipleNumber >= firstPagePosition {
                            yPoint = firstPagePosition
                        }
                        if nearestMultipleNumber <= lastPagePosition {
                            yPoint = lastPagePosition
                        }
                    }
                    if abs(yPoint - previousYPoint) == screen.height {
                        selection += yPoint > previousYPoint ? -1 : 1
                    }
                    previousYPoint = yPoint
                }
            }
        })
        .onAppear {
            self.yPoint = firstPageOffset() - CGFloat(selection) * screen.height
            self.previousYPoint = self.yPoint
        }
    }
    
}
extension VPager {
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
    
    private func nearestMultipleUp(from firstNumber: CGFloat, to secondNumber: CGFloat) -> CGFloat {
        var cleanFirstNumber = abs(firstNumber.rounded())
        
        while cleanFirstNumber.truncatingRemainder(dividingBy: secondNumber) != 0 {
            cleanFirstNumber += 1
        }
        return cleanFirstNumber * (firstNumber < 0 ? -1 : 1)
    }
    
    private func nearestMultipleDown(from firstNumber: CGFloat, to secondNumber: CGFloat) -> CGFloat {
        var cleanFirstNumber = firstNumber.rounded() * (firstNumber < 0 ? -1 : 1)
        
        while cleanFirstNumber.truncatingRemainder(dividingBy: secondNumber) != 0 {
            cleanFirstNumber -= 1
        }
        return cleanFirstNumber * (firstNumber < 0 ? -1 : 1)
    }
}


extension VPager {
    private func firstPageOffset() -> CGFloat {
        let result = screen.height * CGFloat(self.pages.count/2)
        return nearestMultiple(from: result, to: screen.height)
    }
    private func lastPageOffset() -> CGFloat {
        return -firstPageOffset()
    }
}

extension VPager {
    enum ScrollDirection {
        case forward
        case back
    }
}
