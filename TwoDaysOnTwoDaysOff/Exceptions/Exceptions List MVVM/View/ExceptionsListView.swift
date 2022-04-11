//
//  ExceptionsListView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ExceptionsListView: View {
    @ObservedObject private var exceptionListVM = ExceptionListViewModel()
    @State private var isExceptionDetailsViewPresented: Bool = false
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.monthCalendarColorPalette) private var monthCalendarColorPalette
    
    var body: some View {
        NavigationView {
            VStack {
                header
                    .background(colorPalette.backgroundDefault.ignoresSafeArea())
                    .zIndex(1.0)
                List {
                    ForEach(exceptionListVM.exceptions.freeze()) { exception in
                        NavigationLink {
                            if exceptionListVM.selection == .new {
                                LazyView(ExceptionDetailsView(date: exception.from))
                            } else {
                                LazyView(ExceptionDetailsPreview(date: exception.from))
                            }
                        } label: {
                            ExceptionRowLabel(title: exception.name,
                                              subtitle: exception.from.string(format: "dd MMM"),
                                              markerColor: exception.isWorking ? monthCalendarColorPalette.workingDayBackground : monthCalendarColorPalette.restDayBackground)
                        }

                    }
                    .onDelete { indexSet in
                        exceptionListVM.remove(at: indexSet)
                    }
                }
                .id(UUID())
            }
            .listStyle(.inset)
            .sheet(isPresented: $isExceptionDetailsViewPresented, content: {
                NavigationView {
                    ExceptionDetailsView(date: UserSettings.startDate)
                        .environment(\.colorPalette, colorPalette)
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(spacing: 16) {
            if exceptionListVM.listMode != .search {
                title
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            HStack {
                searchTextField
                if exceptionListVM.listMode == .search {
                    cancelSearchButton
                        .transition(.opacity)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var title: some View {
        Text("Exception")
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(
                HStack {
                    switchFilterButton
                    addExceptionButton
                },
                alignment: .trailing)
    }
    
    private var addExceptionButton: some View {
        Button {
            isExceptionDetailsViewPresented = true
        } label: {
            Image(systemName: "plus")
                .renderingMode(.template)
                .foregroundColor(colorPalette.buttonPrimary)
                .font(.title2)
        }
    }
    
    private var switchFilterButton: some View {
        Button {
            withAnimation(.easeOut(duration: 0.1)) {
                exceptionListVM.selection = exceptionListVM.selection.toggled()
            }
        } label: {
            Image(systemName: "archivebox")
        }
        .buttonStyle(DefaultButton(isHighlighted: exceptionListVM.selection == .outbound))
    }
    
    private var searchButton: some View {
        Button {
            
        } label: {
            Image(systemName: "magnifyingglass")
                .renderingMode(.template)
                .foregroundColor(isExceptionDetailsViewPresented ? colorPalette.buttonInactive : colorPalette.buttonPrimary)
                .font(.title2)
        }
    }
    
    private var cancelSearchButton: some View {
        Button("Cancel") {
            withAnimation(.easeInOut(duration: 0.3)) {
                exceptionListVM.listMode = .view
            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var searchTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray.opacity(0.7))
            TextField("", text: $exceptionListVM.searchText)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                exceptionListVM.listMode = .search
                            }
                        }
                )
            if !exceptionListVM.searchText.isEmpty {
                Button {
                    exceptionListVM.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.gray.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 10)))
    }
}

struct ExceptionsListView_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionsListView()
    }
}

extension ExceptionsListView {
    private var exceptionsList: some View {
        ScrollView {
            VStack(spacing: 16) {
                searchTextField
                VStack {
                    ForEach(exceptionListVM.exceptions.freeze()) { exception in
                        Text("")
                        
                        if exception.id != exceptionListVM.exceptions.last?.id {
                            Divider()
                                .padding(.leading, 40)
                        }
                    }
                }
                .padding(.vertical)
                .background(colorPalette.backgroundDefault.clipShape(RoundedRectangle(cornerRadius: 20)))
            }
            .padding(.horizontal)
        }
        .fixFlickering()
    }
}


