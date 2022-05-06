//
//  SaveColorThemeView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 18.04.2022.
//

import SwiftUI

struct SaveColorThemeView: View {
    
    @EnvironmentObject private var viewModel: ColorThemeDetailsViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorPalette) private var colorPalette
    
    @State private var isColorThemeDetailsViewPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            Form {
                Section {
                    HStack {
                        TextField("Название", text: $viewModel.name)
                        if !viewModel.name.isEmpty {
                            withAnimation {
                                clearTextButton
                            }
                        }
                    }
                }
                Section {
                    changeColorsButton
                    if viewModel.mode == .add {
                        Toggle("Установить тему как текущую", isOn: $viewModel.setThemeAsCurrent)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text("")
                    doneButton
                }
            }
        }
        .sheet(isPresented: $isColorThemeDetailsViewPresented) {
            NavigationView {
                ColorThemeDetailsView()
                    .environmentObject(viewModel)
            }
        }
        .ifAvailable.alert(title: "Ошибка",
                           message: Text(viewModel.errorMessage),
                           isPresented: $viewModel.hasError,
                           defaultButtonTitle: Text("OK"))
    }
    
    private var clearTextButton: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(colorPalette.textSecondary)
            .onTapGesture {
                viewModel.name.removeAll()
            }
    }
    
    private var changeColorsButton: some View {
        HStack {
            Text("Изменить цвета")
            Spacer()
            colorThemeLabel
                .onTapGesture {
                    isColorThemeDetailsViewPresented = true
                }
        }
    }
    
    private var colorThemeLabel: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                Gradient.Stop(color: viewModel.restDayBackground, location: 0.5),
                Gradient.Stop(color: viewModel.workingDayBackground, location: 0.5)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
            .clipShape(Circle())
            .frame(width: 25, height: 25)
            .ifAvailable.overlay {
                Circle().stroke(viewModel.accent, lineWidth: 3)
            }
    }
    
    private var doneButton: some View {
        Button {
            viewModel.save()
            if !viewModel.hasError {
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("Готово")
                .font(.headline)
                .foregroundColor(viewModel.isValid ? colorPalette.buttonPrimary : colorPalette.inactive)
        }
        .disabled(!viewModel.isValid)
    }
}

struct SaveColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        SaveColorThemeView()
    }
}
