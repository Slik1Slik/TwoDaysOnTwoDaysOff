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
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK"), action: {
                viewModel.hasError = false
            }))
        }
    }
    
    private var clearTextButton: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
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
            .background(Circle().stroke(viewModel.accent, lineWidth: 3))
            .frame(width: 25, height: 25)
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

//struct SaveColorThemeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveColorThemeView()
//    }
//}
