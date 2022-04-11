//
//  ExceptionRowOld.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 04.04.2022.
//

import SwiftUI

struct ExceptionRow: View, Identifiable {
    
    @Environment(\.monthCalendarColorPalette) private var monthCalendarColorPalette
    
    var id = UUID()
    
    private let date: Date
    private let name: String
    private let isWorking: Bool
    
    var body: some View {
        NavigationLink {
            LazyView(ExceptionDetailsView(date: date))
        } label: {
            HStack {
                colorMark
                title
            }
        }
    }
    
    private var title: some View {
        VStack(spacing: 10) {
            HStack {
                Text(name)
                    .bold()
                Spacer()
            }
            HStack {
                Text(date.string(format: "dd MMM"))
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    
    private var colorMark: some View {
        Capsule(style: .continuous)
            .foregroundColor(isWorking ? monthCalendarColorPalette.workingDayBackground: monthCalendarColorPalette.restDayBackground)
            .frame(maxWidth: 5, maxHeight: .infinity)
    }
    
    init(date: Date, name: String, isWorking: Bool) {
        self.date = date
        self.name = name
        self.isWorking = isWorking
    }
}
