//
//  ExceptionDetailsPreviewAlert.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 04.05.2022.
//

import SwiftUI

struct ExceptionDetailsPreviewAlert: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject private var viewModel: ExceptionDetailsPreviewViewModel = ExceptionDetailsPreviewViewModel()
    
    @Environment(\.colorPalette) private var colorPalette
    
    var body: some View {
        VStack {
            ExceptionDetailsPreview(date: viewModel.date)
                .background(
                    colorPalette.backgroundPrimary
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                )
                .frame(width: 250, height: 250)
        }
    }
    
    init(isPresented: Binding<Bool>, date: Date) {
        self._isPresented = isPresented
        self.viewModel.date = date
    }
}

struct ExceptionPreviewAlert_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionDetailsPreviewAlert(isPresented: .constant(true), date: Date())
    }
}
