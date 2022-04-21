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
    @State private var animation: Animation? = .none
    
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
                        Section(header: header("Name"), footer: footer(viewModel.nameErrorMessage)) {
                            TextField("Name", text: $viewModel.name, onCommit: {
                                endEditing()
                            })
                        }
                        Section(header: header("Period"), footer: footer(viewModel.datesErrorMessage)) {
                            VStack(spacing: 5) {
                                dateRow(
                                    title: viewModel.isPeriod ? "From" : "Date",
                                    selection: $viewModel.from) {
                                        self.isAlertPresented = true
                                        self.caller = .from
                                    }
                                if viewModel.isPeriod {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        dateRow(
                                            title: "To",
                                            selection: $viewModel.to) {
                                                self.isAlertPresented = true
                                                self.caller = .to
                                            }
                                    }
                                }
                                Divider()
                                Toggle("Period", isOn: $viewModel.isPeriod)
                                    .onChange(of: viewModel.isPeriod) { _ in
                                        animation = .linear
                                    }
                            }
                        }
                        if viewModel.isDayKindChangable {
                            Section(header: header("Day kind")) {
                                DayKindPicker(selection: $viewModel.isWorking)
                            }
                        }
                        Section(header: header("Details"), footer: footer("")) {
                            NavigationLink(destination: DetailsTextView(selection: $viewModel.details).environment(\.colorPalette, colorPalette)) {
                                HStack {
                                    Text(viewModel.details)
                                        .foregroundColor(colorPalette.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .renderingMode(.template)
                                        .foregroundColor(colorPalette.buttonPrimary)
                                }
                            }
                        }
                    }
                    .padding()
                    .animation(animation)
                }
                .fixGlitching()
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            endEditing()
                        }
                )
                .background(colorPalette.backgroundForm.ignoresSafeArea())
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
            if isAlertPresented {
                currentDatePicker()
                    .transition(.asymmetric(insertion: .scale.animation(.easeOut), removal: .opacity.animation(.easeIn(duration: 0.1))))
                    .zIndex(1)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("Details")
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
}

extension ExceptionDetailsView {
    
    private var navigationBar: some View {
        Text("Details")
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
                .font(.title)
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            viewModel.save()
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .bold()
                .foregroundColor(viewModel.isValid ? colorPalette.buttonPrimary : colorPalette.inactive)
        }
        .disabled(!viewModel.isValid)
    }
    
    private func header(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.bold())
            Spacer()
        }
        .padding([.horizontal], 5)
    }
    
    private func footer(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.footnote)
                .foregroundColor(Color(.systemRed))
                .lineLimit(1)
            Spacer()
        }
        .padding([.horizontal], 5)
    }
    
    private func detailsFooter() -> some View {
        HStack {
            Spacer()
            HStack {
                Text(viewModel.details.count.description + "/" + "400")
                    .font(.caption)
            }
        }
    }
}

extension ExceptionDetailsView {
    func dateRow(title: String, selection: Binding<Date>, action: @escaping ()->()) -> some View {
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
    
    private func currentDatePicker() -> MonthCalendarDatePickerAlert {
        return caller == .from ? datePickerFrom() : datePickerTo()
    }
    
    private func datePickerFrom() -> MonthCalendarDatePickerAlert {
        let lowerBound = UserSettings.startDate
        let upperBound = viewModel.isPeriod ? viewModel.to : UserSettings.finalDate
        return MonthCalendarDatePickerAlert(
            selection: $viewModel.from,
            range: lowerBound...upperBound,
            isPresented: $isAlertPresented
        )
    }
    
    private func datePickerTo() -> MonthCalendarDatePickerAlert {
        let lowerBound = viewModel.from
        let upperBound = UserSettings.finalDate
        return MonthCalendarDatePickerAlert(
            selection: $viewModel.to,
            range: lowerBound...upperBound,
            isPresented: $isAlertPresented
        )
    }
}

extension ExceptionDetailsView {
    struct DayKindPicker: View {
        @Binding var selection: Bool
        @State private var dayKind: DayKind
        var body: some View {
            Picker("", selection: $dayKind) {
                ForEach(ExceptionDetailsView.DayKind.allCases, id: \.self) { kind in
                    Text(kind.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: dayKind) { kind in
                selection = kind == .working
            }
        }
        init(selection: Binding<Bool>) {
            self._selection = selection
            self.dayKind = selection.wrappedValue ? .working : .dayOff
        }
    }
    
    enum DayKind: String, CaseIterable {
        case working = "Working"
        case dayOff = "Day off"
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
