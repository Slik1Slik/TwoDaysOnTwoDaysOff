//
//  MonthCalendarPage.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.03.2022.
//

import Foundation
import SwiftUI

struct MonthCalendarPage: View {
    var month: Date
    
    @Environment(\.colorPalette) var colorPalette
    private var calendarColorPalette: CalendarColorPalette = ApplicationColorPalette.calendar
    
    private var calendarManager: MonthCalendarManager
    
    @ObservedObject private var viewModel: MonthPageDayViewModel = MonthPageDayViewModel()
    
    var body: some View {
        monthView()
    }
    
    init(month: Date, calendarManager: MonthCalendarManager) {
        self.month = month
        self.calendarManager = calendarManager
        self.viewModel.month = month
    }
    
    @ViewBuilder
    private func monthView() -> some View {
        MonthView(month: month,
                  calendarManager: calendarManager,
                  showsHeader: false,
                  showsWeekdaysRow: false, dateView: { date in
            dayCell(date: date)
                .frame(alignment: .top)
        })
    }
    
    @ViewBuilder
    private func dayCell(date: Date) -> some View {
        if let day = viewModel.day(for: date) {
            if let exception = day.exception {
                exceptionDateView(date: date, isWorking: exception.isWorking)
            } else {
                VStack(spacing: 2) {
                    dateView(date: date, isWorking: day.isWorking)
                    Spacer()
                }
            }
        } else {
            dateViewPlaceholder(date: date)
        }
    }
    
    @ViewBuilder
    private func dateViewPlaceholder(date: Date) -> some View {
        VStack(spacing: 2) {
            DateView(date: date)
                .font(.title3)
                .foregroundColor(colorPalette.textSecondary)
                .frame(width: calendarManager.layoutConfiguration.item.width,
                       height: calendarManager.layoutConfiguration.item.width)
                .disabled(true)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func dateView(date: Date, isWorking: Bool) -> some View {
        DateView(date: date)
            .font(.title3)
            .foregroundColor(isWorking ? calendarColorPalette.workingDayText : calendarColorPalette.restDayText)
            .frame(width: calendarManager.layoutConfiguration.item.width,
                   height: calendarManager.layoutConfiguration.item.width)
            .background(isWorking ? calendarColorPalette.workingDayBackground : calendarColorPalette.restDayBackground)
            .clipShape(Circle())
            .opacity(isDateViewSelected(date: date) ? 0.8 : 1)
            .onTapGesture {
                calendarManager.selectedDate = date
            }
    }
    
    @ViewBuilder
    private func exceptionDateView(date: Date, isWorking: Bool) -> some View {
        VStack(spacing: 2) {
            dateView(date: date, isWorking: isWorking)
            Color.gray
                .frame(width: MonthCalendarLayoutConstants.exceptionMarkCircleSize, height: MonthCalendarLayoutConstants.exceptionMarkCircleSize)
                .clipShape(Circle())
        }
    }
    
    private func isDateViewSelected(date: Date) -> Bool {
        let isCurrentDateViewSelected = (date == calendarManager.selectedDate)
        guard !isCurrentDateViewSelected else { return true }
        guard let day = viewModel.day(for: date),
              let exception = day.exception,
              !exception.isInvalidated,
              exception.from != exception.to else
              {
                  return false
              }
        let exceptionPeriod = (exception.from...exception.to)
        return exceptionPeriod.contains(date) && exceptionPeriod.contains(calendarManager.selectedDate)
    }
}
