//
//  MonthAccessoryView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI
import Combine

struct MonthAccessoryView: View {
    
    @ObservedObject private var viewModel: AccessoryViewExceptionViewModel = AccessoryViewExceptionViewModel()
    
    @State private var isExceptionDetailsViewPresented: Bool = false
    @State private var isRemoveMessageAlertPresented: Bool = false
    
    @Environment(\.colorPalette) var colorPalette
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectValueForCurrentDeviceScreen(10)) {
            if viewModel.isValid && viewModel.exists {
                exceptionHeader
                exceptionDateLabel
                if !viewModel.details.isEmpty {
                    exceptionDetails
                }
                Spacer()
            } else {
                Spacer()
                exceptionDetailsPlaceholder
                Spacer()
            }
        }
        .padding(LayoutConstants.perfectValueForCurrentDeviceScreen(16))
        .frame(maxWidth: .infinity)
        .background(colorPalette.backgroundPrimary.ignoresSafeArea(.all, edges: [.bottom,.horizontal]))
        .sheet(isPresented: $isExceptionDetailsViewPresented) {
            NavigationView {
                ExceptionDetailsView(date: viewModel.date)
                .environment(\.colorPalette, colorPalette)
            }
        }
        .ifAvailable.alert(title: "Ошибка",
                           message: Text(viewModel.errorMessage),
                           isPresented: $viewModel.hasError,
                           defaultButtonTitle: Text("OK"))
        .ifAvailable.alert(title: "Предупреждение",
                           message: Text("Вы уверены, что хотите удалить исключение? Отменить это действие будет невозможно."),
                           isPresented: $isRemoveMessageAlertPresented,
                           primaryButtonTitle: Text("Отмена"),
                           secondaryButtonTitle: Text("Удалить"),
                           primaryButtonAction: { },
                           secondaryButtonAction: { viewModel.remove() })
    }
    
    private var updateExceptionButton: some View {
        Button(action: {
            isExceptionDetailsViewPresented = true
        }, label: {
            Image(systemName: "square.and.pencil")
        })
        .foregroundColor(colorPalette.buttonPrimary)
        .font(.title3)
    }
    
    private var removeExceptionButton: some View {
        Button(action: { isRemoveMessageAlertPresented = true }) {
            Image(systemName: "trash")
        }
        .foregroundColor(colorPalette.buttonPrimary)
        .font(.title3)
    }
    
    private var addExceptionButton: some View {
        Button {
            isExceptionDetailsViewPresented = true
        } label: {
            Image(systemName: "plus")
                .renderingMode(.template)
                .foregroundColor(colorPalette.buttonTertiary)
                .font(.system(size: LayoutConstants.perfectValueForCurrentDeviceScreen(36)).weight(.thin))
        }
    }
    
    private var exceptionHeader: some View {
        HStack {
            exceptionNameLabel
            Spacer()
            controlBox
        }
    }
    
    private var exceptionNameLabel: some View {
        Text(viewModel.name)
            .font(.title3)
            .bold()
            .lineLimit(2)
    }
    
    private var controlBox: some View {
        HStack(spacing: LayoutConstants.perfectValueForCurrentDeviceScreen(5)) {
            removeExceptionButton
            updateExceptionButton
        }
    }
    
    private var exceptionDateLabel: some View {
        return HStack {
            Text(viewModel.exceptionDateIntervalLabel)
                .foregroundColor(colorPalette.textSecondary)
            Spacer()
        }
    }
    
    private var exceptionDetails: some View {
        return HStack {
            Text(viewModel.details)
                .lineLimit(4)
                .font(.caption)
                .foregroundColor(colorPalette.textSecondary)
            Spacer()
        }
    }
    
    private var exceptionDetailsPlaceholder: some View {
        VStack(spacing: 10) {
            Text("Исключение еще не назначено")
                .font(.title3)
                .foregroundColor(colorPalette.textTertiary)
            addExceptionButton
        }
    }
    
    init(date: Date) {
        viewModel.date = date
    }
}

struct MonthAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        MonthAccessoryView(date: Date())
    }
}
