//
//  ExceptionsListView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct ExceptionsListView: View {
    @ObservedObject var exceptionListVM = ExceptionListViewModel()
    var body: some View {
//        List {
//            ForEach(sectionsHeadersTitles(), id: \.self) { section in
//                Section(header: header(title: section)) {
//                    ForEach(exceptionListVM.exceptions, id: \.self) { exception in
//                        if exception.from.monthSymbolAndYear() == section {
//
//                        }
//                    }
//                }
//            }
//        }
        Text("hi")
    }
    private func sectionsHeadersTitles() -> [String] {
        var result = [String]()
        result = exceptionListVM.exceptions.map { exception in
            return exception.from.monthSymbolAndYear()
        }
        return result.uniqueWithSavingOriginalOrder
    }
    
    private func header(title: String) -> some View {
        return Group {
            Text(title)
                .font(.title)
                .foregroundColor(Color(UserSettings.restDayCellColor!))
        }
    }
}

extension ExceptionsListView
{
    struct ExceptionRow: View {
        var exception: Exception
        @State private var rowXPoint: CGFloat = 0
        @State private var rowState: RowState = .normal
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    HStack {
                        Text(exception.name)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width > 0 {
                                    self.rowXPoint = value.translation.width
                                    self.rowState = .edit
                                } else {
                                    if self.rowState == .edit {
                                        self.rowXPoint = value.translation.width
                                    }
                                }
                            }
                            .onEnded { value in
                                if value.translation.width > geometry.size.width / 4 {
                                    self.rowXPoint -= geometry.size.width / 5
                                    self.rowState = .edit
                                } else {
                                    self.rowXPoint = 0
                                    self.rowState = .normal
                                }
                            }
                    )
                    HStack {
                        Spacer()
                        Button(
                            action: {
                            print("works")
                        },
                            label: {
                                Text("Delete")
                                    .foregroundColor(Color.white)
                            })
                        .frame(width: geometry.size.width/5, height: geometry.size.height)
                        .foregroundColor(Color(.systemRed))
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
    enum RowState {
        case normal
        case edit
    }
}

struct ExceptionsListView_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionsListView()
    }
}
