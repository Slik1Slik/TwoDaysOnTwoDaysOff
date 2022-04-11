//
//  MonthAccessoryView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthAccessoryView: View {
    private var date: Date
    @ObservedObject private var viewModel: AccessoryViewExceptionViewModel = AccessoryViewExceptionViewModel()
    
    @State private var isExceptionDetailsViewPresented: Bool = false
    @State private var isRemoveMessageAlertPresented: Bool = false
    
    @ObservedObject private var appObserver = ApplicationObserver()
    
    @Environment(\.colorPalette) var colorPalette
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectPadding(8)) {
            if viewModel.isValid {
                controlBox
                exceptionHeader
                exceptionDetails
                Spacer()
            } else {
                Spacer()
                exceptionDetailsPlaceholder
                Spacer()
            }
        }
        .padding(LayoutConstants.perfectPadding(16))
        .frame(maxWidth: .infinity)
        .background(colorPalette.backgroundDefault.ignoresSafeArea(.all, edges: [.bottom,.horizontal]))
        .sheet(isPresented: $isExceptionDetailsViewPresented) {
            NavigationView {
                ExceptionDetailsView(date: date) {
                    isExceptionDetailsViewPresented = false
                    
                }
                .environment(\.colorPalette, colorPalette)
            }
        }
        .alert(isPresented: $viewModel.isFailed) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $isRemoveMessageAlertPresented) {
            Alert(title: Text("Alert"),
                  message: Text("Are you sure you want to delete this exception?"),
                  primaryButton: .default(Text("Yes"), action: { viewModel.remove() }),
                  secondaryButton: .cancel())
        }
    }
    
    private var updateExceptionButton: some View {
        Button(action: {}) {
            Image(systemName: "square.and.pencil")
        }
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
                .foregroundColor(Color(.systemGray4))
                .font(.system(size: LayoutConstants.perfectPadding(36)).weight(.thin))
        }
    }
    
    private var controlBox: some View {
        HStack(alignment: .lastTextBaseline, spacing: LayoutConstants.perfectPadding(5)) {
            Spacer()
            removeExceptionButton
            updateExceptionButton
        }
    }
    
    private var exceptionHeader: some View {
        HStack {
            Text(viewModel.name)
                .font(.title2)
                .bold()
            Spacer()
            Text(exceptionDateLabel)
                .font(.title3)
        }
    }
    
    private var exceptionDateLabel: String {
        guard viewModel.dateFrom != viewModel.dateTo else { return viewModel.dateFrom.string(format: "dd MMM") }
        
        let dateFromFormat = viewModel.dateFrom.monthNumber == viewModel.dateTo.monthNumber ? "dd" : "dd MMM"
        
        let dateFrom = viewModel.dateFrom.string(format: dateFromFormat)
        let dateTo = viewModel.dateTo.string(format: "dd MMM")
        
        return dateFrom + " - " + dateTo
    }
    
    private var exceptionDetails: some View {
        return HStack {
            Text(viewModel.details)
                .lineLimit(4)
            Spacer()
        }
    }
    
    private var exceptionDetailsPlaceholder: some View {
        VStack(spacing: 10) {
            Text("Исключение еще не назначено")
                .font(.title3)
                .foregroundColor(Color(.systemGray4))
            addExceptionButton
        }
    }
    
    init(date: Date) {
        self.date = date
        viewModel.date = date
    }
}

struct MonthAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        MonthAccessoryView(date: Date())
    }
}

//    .padding(LayoutConstants.perfectPadding(16))
//    .frame(width: UIScreen.main.bounds.width)
//    .background(Color.white.ignoresSafeArea(.all, edges: [.bottom,.horizontal]))


//.background(Color.white.ignoresSafeArea(.all, edges: [.bottom,.horizontal]).clipShape(RoundedRectangle(cornerRadius: 30)).shadow(color: .gray, radius: 0.3))
