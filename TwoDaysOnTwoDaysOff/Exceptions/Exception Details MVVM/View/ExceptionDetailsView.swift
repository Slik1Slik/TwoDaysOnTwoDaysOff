//
//  ExceptionDetailsView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI
import UIKit
import Combine

struct ExceptionDetailsView: View {
    
    @ObservedObject private var viewModel: ExceptionDetailsViewModel
    
    @State private var isAlertPresented = false
    @State private var caller = DatePickerCaller.from
    @State private var brightness: Double = 0
    @State private var formAnimation: Animation? = .none
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.presentationMode) private var presentationMode
    
    private var onAccept: () -> () = {}
    private var onCancel: () -> () = {}
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navigationBar
                Divider()
                ScrollView {
                    VStack(spacing: 16) {
                        Section(header: header("НАЗВАНИЕ"), footer: footer(viewModel.nameErrorMessage)) {
                            TextField(viewModel.nameTextFieldPlaceholder, text: $viewModel.name, onCommit: {
                                endEditing()
                            })
                        }
                        Section(header: header("ПЕРИОД"), footer: footer(viewModel.datesErrorMessage)) {
                            VStack(spacing: 10) {
                                dateRow(
                                    title: viewModel.isPeriod ? "Начало" : "Дата",
                                    selection: $viewModel.from) {
                                        self.isAlertPresented = true
                                        self.caller = .from
                                    }
                                if viewModel.isPeriod {
                                    dateRow(
                                        title: "Завершение",
                                        selection: $viewModel.to) {
                                            self.isAlertPresented = true
                                            self.caller = .to
                                        }
                                }
                                Divider()
                                    .padding(.trailing, -LayoutConstants.perfectPadding(16))
                                Toggle("Период", isOn: $viewModel.isPeriod)
                            }
                        }
                        if viewModel.isDayKindChangable {
                            Section(header: header("ДЕНЬ")) {
                                DayKindPicker(selection: $viewModel.isWorking)
                                    .environment(\.colorPalette, colorPalette)
                            }
                        }
                        Section(header: header("ДЕТАЛИ"), footer: footer("")) {
                            NavigationLink(destination: DetailsTextView(selection: $viewModel.details).environment(\.colorPalette, colorPalette)) {
                                HStack {
                                    Text(detailsText)
                                        .foregroundColor(colorPalette.textTertiary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .renderingMode(.template)
                                        .foregroundColor(colorPalette.buttonPrimary)
                                }
                            }
                        }
                    }
                    .padding(LayoutConstants.perfectPadding(16))
                    .animation(formAnimation)
                }
                .fixGlitching()
                .background(colorPalette.backgroundSecondary.ignoresSafeArea())
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .brightness(brightness)
            .disabled(isAlertPresented)
            .onChange(of: isAlertPresented) { value in
                if value {
                    self.darken()
                } else {
                    self.illuminate()
                }
            }
            .zIndex(1)
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        endEditing()
                        isAlertPresented = false
                        if formAnimation == .none {
                            formAnimation = .linear
                        }
                    }
            )
            if isAlertPresented {
                currentDatePicker()
                    .transition(.asymmetric(insertion: .scale.animation(.easeOut), removal: .opacity.animation(.easeIn(duration: 0.1))))
                    .zIndex(1)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func darken() {
        withAnimation(.easeOut) {
            self.brightness = -0.2
        }
    }
    
    private func illuminate() {
        withAnimation(.easeOut(duration: 0.1)) {
            self.brightness = 0
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private var detailsText: String {
        return viewModel.details.isEmpty ? "Описание" : viewModel.details
    }
}

extension ExceptionDetailsView {
    
    private var navigationBar: some View {
        Text("Детали")
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(
                HStack{
                    if (viewModel as? UpdateExceptionViewModel) != nil {
                        backButton
                    }
                    Spacer()
                    doneButton
                }
            )
            .padding()
        
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(colorPalette.buttonPrimary)
                .font(.title2)
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            viewModel.save()
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Готово")
                .bold()
                .foregroundColor(viewModel.isValid ? colorPalette.buttonPrimary : colorPalette.inactive)
        }
        .disabled(!viewModel.isValid)
    }
    
    private func header(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.uppercaseSmallCaps())
                .foregroundColor(colorPalette.inactive)
            Spacer()
        }
        .padding(.horizontal, LayoutConstants.perfectPadding(10))
        .padding(.bottom, LayoutConstants.perfectPadding(5))
    }
    
    private func footer(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.footnote)
                .foregroundColor(Color(.systemRed))
                .lineLimit(1)
            Spacer()
        }
        .padding(5)
    }
}

extension ExceptionDetailsView {
    private func dateRow(title: String, selection: Binding<Date>, action: @escaping ()->()) -> some View {
        HStack {
            Text(title)
            Spacer()
            Button {
                action()
            } label: {
                Text(selection.wrappedValue.string(format: "dd MMM, YYYY"))
                    .foregroundColor(colorPalette.buttonPrimary)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(.systemGray6))
                    )
            }
            
        }
    }
    
    private func currentDatePicker() -> DatePickerAlert {
        return caller == .from ? datePickerFrom() : datePickerTo()
    }
    
    private func datePickerFrom() -> DatePickerAlert {
        let lowerBound = Date().startOfDay
        let upperBound = viewModel.isPeriod ? viewModel.to : UserSettings.finalDate
        return DatePickerAlert(initialDate: viewModel.from, range: lowerBound...upperBound) { date in
            viewModel.from = date
            isAlertPresented = false
        }
    }
    
    private func datePickerTo() -> DatePickerAlert {
        let lowerBound = viewModel.from
        let upperBound = UserSettings.finalDate
        return DatePickerAlert(initialDate: viewModel.to, range: lowerBound...upperBound) { date in
            viewModel.to = date
            isAlertPresented = false
        }
    }
}

extension ExceptionDetailsView {
    typealias Section = CustomSection
}

extension ExceptionDetailsView {
    init(date: Date, onAccept: @escaping () -> () = {}) {
        self.viewModel = ExceptionViewModelFactory(date: date).viewModel()
        self.onAccept = onAccept
    }
}

extension ExceptionDetailsView {
    enum DatePickerCaller {
        case from
        case to
    }
}

struct ExceptionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionDetailsView(date: Date())
    }
}
