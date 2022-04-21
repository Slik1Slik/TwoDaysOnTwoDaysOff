//
//  ColorThemeDetailsView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.04.2022.
//

import SwiftUI

struct ColorThemeDetailsView: View {
    
    @EnvironmentObject private var viewModel: ColorThemeDetailsViewModel
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            colorThemeComponentPicker
                .padding()
            MonthCalendarPagePreview()
                .environmentObject(viewModel)
            Divider()
                .padding(.horizontal)
            ZStack {
                CustomColorPicker(selection: $viewModel.restDayBackground)
                    .background(colorPalette.backgroundForm.ignoresSafeArea())
                    .zIndex(viewModel.currentColorThemeComponentToChange == .restDayBackground ? 3 : 0)
                CustomColorPicker(selection: $viewModel.workingDayBackground)
                    .background(colorPalette.backgroundForm.ignoresSafeArea())
                    .zIndex(viewModel.currentColorThemeComponentToChange == .workingDayBackground ? 3 : 1)
                CustomColorPicker(selection: $viewModel.accent, minOpacity: 30/255)
                    .background(colorPalette.backgroundForm.ignoresSafeArea())
                    .zIndex(viewModel.currentColorThemeComponentToChange == .accent ? 3 : 2)
            }
            Spacer()
        }
        .navigationTitle("Цвета")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    doneButton
                    Text("")
                }
            }
        }
        .background(colorPalette.backgroundForm.ignoresSafeArea())
    }
    
    private var colorThemeComponentPicker: some View {
        Picker("", selection: $viewModel.currentColorThemeComponentToChange) {
            ForEach(ColorThemeDetailsViewModel.ColorThemeComponent.allCases, id: \.self) { component in
                Text(component.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var doneButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Готово")
                .font(.headline)
                .foregroundColor(viewModel.accent)
        }
    }
}

struct ColorThemeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemeDetailsView()
    }
}
