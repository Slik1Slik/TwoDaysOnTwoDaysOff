//
//  DateView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct DateView: DateViewProtocol {
    
    var date: Date
    @ObservedObject private var dayViewModel = DayViewModel()
    
    private let itemHeight: CGFloat = ExpandedMonthCalendarConstants.itemWidth
    @State private var isSelected: Bool = false
    @GestureState private var gestureState = TapInfo.inactive
    @State private var opacity: Double = 1
    
    var body: some View {
        VStack(spacing: 5) {
            Text(String(date.day!))
                .font(.title3)
                .foregroundColor(textColor())
                .frame(width: ExpandedMonthCalendarConstants.itemWidth,
                       height: ExpandedMonthCalendarConstants.itemWidth)
                .background(backgroundColor())
                .clipShape(Circle())
                .opacity(opacity)
                .onAppear(perform: {
                    self.dayViewModel.date = date
                })
                .sheet(isPresented: $isSelected) {
                    ExceptionDetailsView()
                }
                .onTapGesture {
                    self.isSelected = true
                    self.onTapGestureAction()
                }
        }
    }
    
    private func backgroundColor() -> Color {
        guard let day = dayViewModel.day else {
            return .clear
        }
        return day.isWorking ? Color(UserSettings.workingDayCellColor!) : Color(UserSettings.restDayCellColor!)
    }
    
    private func textColor() -> Color {
        guard let day = dayViewModel.day else {
            return Color(.lightGray)
        }
        return day.isWorking ? Color.black : Color.white
    }
    
    private func onTapGestureAction() {
        self.opacity = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.opacity = 1
        }
    }
    
    init(date: Date) {
        self.date = date
        self.dayViewModel.date = date
    }
}

extension DateView {
    enum TapInfo {
        case active
        case inactive
        
        var isActive: Bool {
            switch self {
            case .active: return true
            case .inactive: return false
            }
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(date: Date())
    }
}
