//
//  ExceptionRow.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 30.03.2022.
//

import SwiftUI

struct ExceptionRowLabel: View, Identifiable {
    
    var id = UUID()
    
    private let title: String
    private let subtitle: String
    private let markerColor: Color
    
    var body: some View {
        HStack {
            colorMark
            header
        }
    }
    
    private var header: some View {
        VStack(spacing: 10) {
            HStack {
                Text(title)
                    .bold()
                Spacer()
            }
            HStack {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    
    private var colorMark: some View {
        Capsule(style: .continuous)
            .foregroundColor(markerColor)
            .frame(maxWidth: 5, maxHeight: .infinity)
    }
    
    init(title: String, subtitle: String, markerColor: Color) {
        self.title = title
        self.subtitle = subtitle
        self.markerColor = markerColor
    }
}
