//
//  ExceptionsListView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ExceptionsListView: View {
    
    @ObservedObject private var viewModel = ExceptionListViewModel()
    
    @State private var isDetailsExceptionViewPresentedForAdding: Bool = false
    @State private var isDetailsExceptionViewPresentedForUpdating: Bool = false
    @State private var isDetailsExceptionViewPresentedForPreview: Bool = false
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.calendarColorPalette) private var calendarColorPalette
    
    var body: some View {
        VStack {
            navigationBar
                .background(colorPalette.backgroundPrimary.ignoresSafeArea())
                .zIndex(1.0)
            if viewModel.exceptions.count > 0 {
                exceptionList
            } else {
                switch viewModel.listMode {
                case .search:
                    Spacer()
                case .view:
                    exceptionListPlaceholder
                default:
                    exceptionListPlaceholder
                }
            }
        }
        .sheet(isPresented: $isDetailsExceptionViewPresentedForAdding, content: {
            NavigationView {
                ExceptionDetailsView(date: viewModel.nearestAvailableDate!)
                    .environment(\.colorPalette, colorPalette)
            }
        })
        .sheet(isPresented: $isDetailsExceptionViewPresentedForUpdating, content: {
            NavigationView {
                ExceptionDetailsView(date: viewModel.selectedException!.from)
                    .environment(\.colorPalette, colorPalette)
            }
        })
        .sheet(isPresented: $isDetailsExceptionViewPresentedForPreview, content: {
            NavigationView {
                NavigationViewWrapper(title: Text("Детали").bold(),
                                      leadingItem: (Content: EmptyView(), DismissOnTap: false)) {
                    ExceptionDetailsPreview(date: viewModel.selectedException!.from)
                        .environment(\.colorPalette, colorPalette)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarHidden(true)
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .ifAvailable.alert(title: "Ошибка",
                           message: Text(viewModel.errorMessage),
                           isPresented: $viewModel.hasError,
                           defaultButtonTitle: Text("OK"))
    }
    
    @ViewBuilder
    private var navigationBar: some View {
        VStack(spacing: 16) {
            if viewModel.listMode != .search {
                title
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            HStack {
                searchTextField
                if viewModel.listMode == .search {
                    cancelSearchButton
                        .transition(.opacity)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var title: some View {
        Text("Исключения")
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .ifAvailable.overlay(alignment: .trailing) {
                HStack {
                    switchFilterButton
                    if let _ = viewModel.nearestAvailableDate {
                        addExceptionButton
                    }
                }
            }
    }
    
    private var addExceptionButton: some View {
        Button {
            isDetailsExceptionViewPresentedForAdding = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
        }
        .foregroundColor(colorPalette.buttonPrimary)
    }
    
    private var switchFilterButton: some View {
        Button {
            withAnimation(.easeOut(duration: 0.1)) {
                viewModel.selection = viewModel.selection.toggled()
            }
        } label: {
            Image(systemName: "archivebox")
        }
        .padding(5)
        .background(viewModel.selection == .outbound ? colorPalette.buttonPrimary : .clear)
        .cornerRadius(8)
        .foregroundColor(viewModel.selection == .outbound ? colorPalette.highlighted : colorPalette.buttonPrimary)
        .font(.title2)
    }
    
    private var cancelSearchButton: some View {
        Button("Отмена") {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.listMode = .view
                viewModel.searchText = ""
            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var searchTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray.opacity(0.7))
            TextField("", text: $viewModel.searchText)
                .disableAutocorrection(true)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.listMode = .search
                            }
                        }
                )
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(colorPalette.textTertiary)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.gray.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 10)))
    }
    
    private var exceptionList: some View {
        List {
            ForEach(viewModel.exceptions.freeze()) { exception in
                LazyView(
                    Button {
                        if viewModel.selection == .new {
                            viewModel.selectedException = exception
                            isDetailsExceptionViewPresentedForUpdating = true
                        } else {
                            viewModel.selectedException = exception
                            isDetailsExceptionViewPresentedForPreview = true
                        }
                    } label: {
                        ExceptionRowLabel(title: exception.name,
                                          subtitle: viewModel.dateIntervalLabelFor(exception),
                                          markerColor: exception.isWorking ? calendarColorPalette.workingDayBackground : calendarColorPalette.restDayBackground)
                            .environment(\.colorPalette, colorPalette)
                    }
                )
            }
            .onDelete { indexSet in
                viewModel.remove(at: indexSet)
            }
        }
        .environment(\.locale, Locale(identifier: "ru"))
        .listStyle(.inset)
        .id(UUID())
    }
    
    private var exceptionListPlaceholder: some View {
        Text("Исключения не назначены")
            .font(.title2)
            .foregroundColor(colorPalette.textTertiary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(LayoutConstants.perfectValueForCurrentDeviceScreen(16))
    }
}

struct ExceptionsListView_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionsListView()
    }
}

