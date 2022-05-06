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
    
    @State private var isDatePickerAlertPresented = false
    @State private var isFoundExceptionPreviewAlertPresented = false
    @State private var caller = DatePickerCaller.from
    @State private var brightness: Double = 0
    @State private var formAnimation: Animation? = .none
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.presentationMode) private var presentationMode
    
    private var onAccept: () -> () = {}
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navigationBar
                Divider()
                ScrollView {
                    VStack(spacing: 16) {
                        nameSection
                        periodSection
                        if viewModel.isDayKindChangable {
                            dayKindSection
                        }
                        detailsSection
                    }
                    .padding(LayoutConstants.perfectValueForCurrentDeviceScreen(16))
                    .animation(formAnimation)
                }
                .fixGlitching()
                .background(colorPalette.backgroundSecondary.ignoresSafeArea())
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .brightness(brightness)
            .disabled(isDatePickerAlertPresented || isFoundExceptionPreviewAlertPresented)
            .onChange(of: isDatePickerAlertPresented) { value in
                if value {
                    self.darken()
                } else {
                    self.illuminate()
                }
            }
            .onChange(of: isFoundExceptionPreviewAlertPresented) { value in
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
                        isDatePickerAlertPresented = false
                        isFoundExceptionPreviewAlertPresented = false
                        if formAnimation == .none {
                            formAnimation = .linear
                        }
                    }
            )
            if isDatePickerAlertPresented {
                currentDatePicker()
                    .transition(.asymmetric(insertion: .scale.animation(.easeOut), removal: .opacity.animation(.easeIn(duration: 0.1))))
                    .zIndex(1)
            }
            if isFoundExceptionPreviewAlertPresented {
                if let exception = viewModel.foundConflictException {
                    ExceptionDetailsPreviewAlert(isPresented: $isFoundExceptionPreviewAlertPresented, date: exception.from)
                    .transition(.asymmetric(insertion: .scale.animation(.easeOut), removal: .opacity.animation(.easeIn(duration: 0.1))))
                    .zIndex(1)
                }
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
            .ifAvailable.overlay({
                HStack{
                    Spacer()
                    doneButton
                }
            })
            .padding()
        
    }
    
    private var doneButton: some View {
        Button(action: {
            viewModel.save()
            if !viewModel.hasError {
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Готово")
                .bold()
                .foregroundColor(viewModel.isValid ? colorPalette.buttonPrimary : colorPalette.inactive)
        }
        .disabled(!viewModel.isValid)
        .ifAvailable.alert(title: "Ошибка",
                           message: Text(viewModel.anyErrorMessage),
                           isPresented: $viewModel.hasError,
                           defaultButtonTitle: Text("OK"))
    }
    
    private func header(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.uppercaseSmallCaps())
                .foregroundColor(colorPalette.textSecondary)
            Spacer()
        }
        .padding(.horizontal, LayoutConstants.perfectValueForCurrentDeviceScreen(10))
        .padding(.bottom, LayoutConstants.perfectValueForCurrentDeviceScreen(5))
    }
    
    private func footer(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.footnote)
                .foregroundColor(Color(.systemRed))
                .lineLimit(2)
            Spacer()
        }
        .padding(5)
    }
}

extension ExceptionDetailsView {
    private var nameSection: some View {
        Section(header: header("НАЗВАНИЕ"), footer: footer(viewModel.nameErrorMessage)) {
            TextField(viewModel.nameTextFieldPlaceholder, text: $viewModel.name, onCommit: {
                endEditing()
                if viewModel.name.isEmpty {
                    viewModel.name = viewModel.nameTextFieldPlaceholder
                }
            })
        }
    }
}

extension ExceptionDetailsView {
    
    private var periodSection: some View {
        Section(header: header("ПЕРИОД"), footer: periodFooter()) {
            VStack(spacing: 10) {
                dateRow(
                    title: viewModel.isPeriod ? "Начало" : "Дата",
                    selection: $viewModel.from) {
                        self.isDatePickerAlertPresented = true
                        self.caller = .from
                    }
                if viewModel.isPeriod {
                    dateRow(
                        title: "Завершение",
                        selection: $viewModel.to) {
                            self.isDatePickerAlertPresented = true
                            self.caller = .to
                        }
                }
                Divider()
                    .padding(.trailing, -LayoutConstants.perfectValueForCurrentDeviceScreen(16))
                Toggle("Период", isOn: $viewModel.isPeriod)
            }
        }
    }
    
    private func dateRow(title: String, selection: Binding<Date>, action: @escaping ()->()) -> some View {
        HStack {
            Text(title)
            Spacer()
            Button {
                action()
            } label: {
                Text(selection.wrappedValue.string(format: "d MMM, YYYY"))
                    .foregroundColor(colorPalette.buttonPrimary)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(colorPalette.backgroundTertiary)
                    )
            }
            
        }
    }
    
    private func currentDatePicker() -> DatePickerAlert {
        return caller == .from ? datePickerFrom() : datePickerTo()
    }
    
    private func datePickerFrom() -> DatePickerAlert {
        let lowerBound = viewModel.availableDateIntervalForException.start
        let upperBound = viewModel.isPeriod ? viewModel.to : viewModel.availableDateIntervalForException.end
        return DatePickerAlert(initialDate: viewModel.from, range: lowerBound...upperBound) { date in
            viewModel.from = date
            isDatePickerAlertPresented = false
        }
    }
    
    private func datePickerTo() -> DatePickerAlert {
        let lowerBound = viewModel.from
        let upperBound = UserSettings.finalDate
        return DatePickerAlert(initialDate: viewModel.to, range: lowerBound...upperBound) { date in
            viewModel.to = date
            isDatePickerAlertPresented = false
        }
    }
    
    private func periodFooter() -> some View {
        HStack {
            Text(viewModel.datesErrorMessage)
                .font(.footnote)
                .foregroundColor(Color(.systemRed))
                .lineLimit(2)
            Spacer()
            presentFoundExceptionPreviewButton
                .opacity((!viewModel.isValid && viewModel.foundConflictException != nil) ? 1 : 0)
        }
        .padding(5)
    }
    
    private var presentFoundExceptionPreviewButton: some View {
        Button {
            isFoundExceptionPreviewAlertPresented = true
        } label: {
            Image(systemName: "info.circle")
        }
        .foregroundColor(Color(.systemRed))
    }
}

extension ExceptionDetailsView {
    
    private var dayKindSection: some View {
        Section(header: header("ДЕНЬ")) {
            DayKindPicker(selection: $viewModel.isWorking)
                .environment(\.colorPalette, colorPalette)
        }
    }
}

extension ExceptionDetailsView {
    
    private var detailsSection: some View {
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
