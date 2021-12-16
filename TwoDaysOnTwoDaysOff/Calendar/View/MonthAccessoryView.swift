//
//  MonthAccessoryView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthAccessoryView: View {
    private var date: Date
    @ObservedObject private var viewModel: ExceptionsViewModel = ExceptionsViewModel()
    
    @State private var isExceptionDetailsViewPresented: Bool = false
    @State private var isRemoveMessageAlertPresented: Bool = false
    
    var body: some View {
        VStack(spacing: LayoutConstants.perfectPadding(15)) {
            if let _ = viewModel.exception {
                controlBox
                exceptionHeader
                exceptionDetails
                Spacer()
            } else {
                exceptionDetailsPlaceholder
            }
        }
        .clipped()
        .sheet(isPresented: $isExceptionDetailsViewPresented) {
            ExceptionDetailsView(date: date) {
                isExceptionDetailsViewPresented = false
            }
        }
        .alert(isPresented: $viewModel.isFailed) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $isRemoveMessageAlertPresented) {
            Alert(title: Text("Alert"),
                  message: Text("Are you sure you want to delete this exception?"),
                  primaryButton: .default(Text("Yes"), action: {
                    viewModel.remove()
                  }),
                  secondaryButton: .cancel())
        }
    }
    
    private var updateExceptionButton: some View {
        Button {
            isExceptionDetailsViewPresented = true
        } label: {
            Image(systemName: "square.and.pencil")
                .renderingMode(.template)
                .foregroundColor(Color(UserSettings.restDayCellColor!))
                .font(.title3)
        }
    }
    
    private var removeExceptionButton: some View {
        Button {
            isRemoveMessageAlertPresented = true
        } label: {
            Image(systemName: "trash")
                .renderingMode(.template)
                .foregroundColor(Color(UserSettings.restDayCellColor!))
                .font(.title3)
        }
    }
    
    private var addExceptionButton: some View {
        Button {
            isExceptionDetailsViewPresented = true
        } label: {
            Image(systemName: "plus")
                .renderingMode(.template)
                .foregroundColor(Color(.systemGray4))
                .font(.system(size: LayoutConstants.perfectPadding(60)).weight(.thin))
        }
    }
    
    private var controlBox: some View {
        HStack(alignment: .lastTextBaseline, spacing: LayoutConstants.perfectPadding(5)) {
            Spacer()
            removeExceptionButton
            updateExceptionButton
        }
        .animation(.easeOut)
    }
    
    private var exceptionHeader: some View {
        HStack {
            Text(viewModel.exception!.name)
                .font(.title2)
                .bold()
            Spacer()
        }
    }
    
    private var exceptionDetails: some View {
        let dateFrom = viewModel.exception!.from.string(format: "dd MMM")
        let dateTo = viewModel.exception!.to.string(format: "dd MMM")
        let dateLabel = (viewModel.exception!.from != viewModel.exception!.to) ? dateFrom + " - " + dateTo : dateFrom
        return VStack {
            HStack {
                Text(dateLabel)
                    .font(.title3)
                Spacer()
            }
            .layoutPriority(100)
            HStack {
                Text(viewModel.exception!.details)
                    .lineLimit(4)
                Spacer()
            }
            .layoutPriority(100)
        }
    }
    
    private var exceptionDetailsPlaceholder: some View {
        VStack(spacing: 15) {
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
