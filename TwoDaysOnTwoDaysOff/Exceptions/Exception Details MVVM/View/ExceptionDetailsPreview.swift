//
//  ExceptionDetailsPreview.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 04.04.2022.
//

import SwiftUI

struct ExceptionDetailsPreview: View {
    
    private var viewModel: ExceptionDetailsPreviewViewModel = ExceptionDetailsPreviewViewModel()
    
    @Environment(\.colorPalette) private var colorPalette
    
    var body: some View {
        VStack(spacing: 16) {
            titleLabel
            dayKindLabel
            dateIntervalLabel
            if !viewModel.details.isEmpty {
                detailsLabel
            }
            Spacer()
        }
        .padding(LayoutConstants.perfectValueForCurrentDeviceScreen(16))
    }
    
    private var titleLabel: some View {
        HStack {
            Text(viewModel.name)
                .font(.title2.bold())
                .lineLimit(2)
            Spacer()
        }
    }
    
    private var dayKindLabel: some View {
        HStack {
            Text("Внеплановый \(viewModel.isWorking ? "рабочий" : "выходной") день")
                .font(.body)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var dateIntervalLabel: some View {
        HStack {
            Text(viewModel.exceptionDateIntervalLabel)
                .font(.caption)
                .foregroundColor(colorPalette.textTertiary)
            Spacer()
        }
    }
    
    private var detailsLabel: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Описание:")
                    .font(.caption)
                    .foregroundColor(colorPalette.textTertiary)
                Spacer()
            }
            HStack {
                Text(viewModel.details)
                    .font(.caption)
                    .foregroundColor(colorPalette.textTertiary)
                Spacer()
            }
        }
    }
    
    init(date: Date) {
        self.viewModel.date = date
    }
}

struct ExceptionDetailsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionDetailsPreview(date: Date())
    }
}
