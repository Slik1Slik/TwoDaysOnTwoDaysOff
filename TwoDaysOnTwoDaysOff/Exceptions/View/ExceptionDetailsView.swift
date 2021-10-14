//
//  ExceptionDetailsView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI
import UIKit

struct ExceptionDetailsView: View {
    @ObservedObject private var viewModel = ExceptionViewModel()
    @State private var isAlertPresented = false
    @State private var caller = DatePickerCaller.from
    @State private var brightness: Double = 0
    
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
                                dateRow(
                                    title: "To",
                                    selection: $viewModel.to) {
                                    self.isAlertPresented = true
                                    self.caller = .to
                                }
                                .animation(.easeOut(duration: 0.3))
                            }
                            Divider()
                            Toggle("Period", isOn: $viewModel.isPeriod)
                        }
                        .animation(.linear(duration: 0.2))
                    }
                    Section(header: header("Day kind")) {
                        Toggle("Is working", isOn: $viewModel.isWorking)
                    }
                    Section(header: header("Icon")) {
                        ExceptionIconPicker(selection: $viewModel.icon)
                    }
                    Section(header: header("Details"), footer: detailsFooter()) {
                        TextEditor(text: $viewModel.details)
                            .autocapitalization(.sentences)
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationBarItems(
                trailing:
                    Button("Done", action: {
                        print("")
                    })
                    .disabled(!viewModel.isValid)
            )
            .navigationBarTitle("Exception", displayMode: .inline)
        }
        .brightness(brightness)
        .disabled(isAlertPresented)
        .overlay(
            WheelDatePickerAlert(
                isPresented: $isAlertPresented,
                selection: caller == .from ? $viewModel.from : $viewModel.to,
                range: caller == .from ? Date()...UserSettings.finalDate : viewModel.from...UserSettings.finalDate
            )
        )
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
    }
    
//    Button("Done", action: {
//        print("")
//    })
//    .disabled(!viewModel.isValid)
    
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
                    .foregroundColor(viewModel.details.count < 400 ? Color(.label) : Color(.systemRed))
                    .lineLimit(1)
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
                    .foregroundColor(Color(.link))
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(.systemGray6))
                    )
                    .animation(.easeOut)
            }
            
        }
    }
}

extension ExceptionDetailsView {
    typealias Section = CustomSection
}

extension ExceptionDetailsView {
    enum DatePickerCaller {
        case from
        case to
    }
}

struct ExceptionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionDetailsView()
    }
}
