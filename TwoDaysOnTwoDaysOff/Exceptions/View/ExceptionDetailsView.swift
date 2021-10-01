//
//  ExceptionDetailsView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ExceptionDetailsView: View {
    @ObservedObject private var viewModel = ExceptionViewModel()
    @State private var isAlertPresented = false
    @State private var caller = DatePickerCaller.from
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Section(header: header("Name"), footer: footer(viewModel.nameErrorMessage)) {
                    TextField("Name", text: $viewModel.name)
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
                    .animation(.linear(duration: 0.3))
                }
            }
            .padding()
            .blur(radius: isAlertPresented ? 3 : 0)
        }
        .background(Color(.systemGray6))
        .overlay(
            WheelDatePickerAlert(
                isPresented: $isAlertPresented,
                selection: caller == .from ? $viewModel.from : $viewModel.to,
                range: caller == .from ? Date()...UserSettings.finalDate : viewModel.from...UserSettings.finalDate
            )
        )
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
