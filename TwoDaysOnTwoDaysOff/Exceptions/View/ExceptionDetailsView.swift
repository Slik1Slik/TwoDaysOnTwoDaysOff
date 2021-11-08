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
    @ObservedObject private var viewModel: ExceptionViewModel
    @State private var isAlertPresented = false
    @State private var caller = DatePickerCaller.from
    @State private var brightness: Double = 0
    @State private var animation: Animation? = .none
    
    @ObservedObject private var keyboardObserver = KeyboardObserver()
    
    var body: some View {
        NavigationView {
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
                        }
                    }
                    Section(header: header("Day kind")) {
                        Toggle("Is working", isOn: $viewModel.isWorking)
                            .disabled(!viewModel.isDayKindChangable)
                    }
                    Section(header: header("Details"), footer: detailsFooter()) {
                        TextEditor(text: $viewModel.details)
                            .autocapitalization(.sentences)
                            .onReceive(Just(viewModel.details)) { _ in
                                if viewModel.details.count > 400 {
                                    viewModel.details = String(viewModel.details.prefix(400))
                                }
                            }
                            .lineLimit(5)
                    }
                }
                .padding()
                .animation(animation)
            }
            .background(Color(.systemGray6))
            .navigationBarItems(
                trailing:
                    Button("Done", action: {
                        viewModel.save()
                    })
                    .disabled(!viewModel.isValid)
            )
            .navigationBarTitle("Exception", displayMode: .inline)
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
        .onTapGesture {
            guard !isAlertPresented else {
                return
            }
            endEditing()
        }
        .overlay(
            currentDatePicker()
        )
    }
    
    private func darken() {
        withAnimation(.easeOut) {
            self.brightness = -0.5
        }
    }
    
    private func illuminate() {
        withAnimation(.easeOut(duration: 0.05)) {
            self.brightness = 0
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension ExceptionDetailsView {
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
                .animation(.easeOut)
            Spacer()
            Button {
                action()
            } label: {
                Text(selection.wrappedValue.string(format: "dd MMM, YYYY"))
                    .foregroundColor(Color(.link))
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
                ForEach(ExceptionDetailsView.DayKind.allCases, id: \.self) {
                    Text($0.rawValue)
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
    init(date: Date) {
        self.viewModel = ExceptionViewModelFactory(date: date).viewModel()
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
