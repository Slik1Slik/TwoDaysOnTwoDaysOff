//
//  CustomList.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 04.04.2022.
//

import SwiftUI

struct CustomList<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable, Data.Element: Hashable, Data.Index: Hashable {
    var data: Data
    @Binding var listMode: ListMode
    var content: (Data.Element) -> Content
    var onDelete: (IndexSet) -> () = { _ in }
    
    @Environment(\.colorPalette) private var colorPalette
    
    @State private var draggedItemXPoint: CGFloat = 0
    @State private var draggedItemIndexHash: Int = 0
    
    @State private var selectedIndeciesHashValues = [Int]()
    
    private let maxItemXPoint: CGFloat = -30
    
    var body: some View {
        VStack {
            ForEach(data) { element in
                ZStack {
                    content(element)
                        .offset(x: element.id.hashValue == draggedItemIndexHash ? draggedItemXPoint : 0)
                        .disabled(true)
                        .highPriorityGesture(
                            DragGesture(minimumDistance: 10)
                                .onChanged{ value in
                                    guard value.translation.width < -10 else { return }
                                    withAnimation {
                                        draggedItemXPoint = CGFloat.maximum(value.translation.width, maxItemXPoint)
                                    }
                                }
                                .onEnded{ value in
                                    guard draggedItemXPoint <= -30 else {
                                        withAnimation {
                                            draggedItemXPoint = 0
                                        }
                                        return
                                    }
                                    withAnimation {
                                        if listMode == .edit {
                                            listMode = .view
                                            selectedIndeciesHashValues.removeAll()
                                        } else {
                                            listMode = .edit
                                            draggedItemIndexHash = element.id.hashValue
                                        }
                                        draggedItemXPoint = 0
                                    }
                                    DispatchQueue.main.async {
                                        AppHapticEngine.shared.play(.singleTap)
                                    }
                                }
                        )
                        .zIndex(0)
                    if listMode == .edit {
                        HStack {
                            Spacer()
                            marker(isSelected: selectedIndeciesHashValues.contains(element.id.hashValue))
                        }
                        .onTapGesture {
                            onMarkerTapped(elementIDHashValue: element.id.hashValue)
                        }
                        .zIndex(1)
                    }
                }
                if element.id != data.last?.id {
                    Divider()
                        .padding(.leading, 40)
                }
            }
            .onDelete { indexSet in
                onDelete(indexSet)
            }
        }
    }
    
    private var circleOutline: some View {
        Circle()
            .stroke(lineWidth: 1)
    }
    
    private var circle: some View {
        Circle()
            .scaleEffect(0.7)
    }
    
    @ViewBuilder
    private func marker(isSelected: Bool) -> some View {
        if listMode == .view { Color.clear.frame(width: 0, height: 0) } else {
            HStack {
                Spacer()
                if isSelected {
                    circleOutline
                        .overlay(circle)
                        .foregroundColor(colorPalette.buttonPrimary.opacity(0.8))
                        .frame(width: 23, height: 23, alignment: .center)
                } else {
                    circleOutline
                        .foregroundColor(colorPalette.buttonInactive.opacity(0.8))
                        .frame(width: 23, height: 23, alignment: .center)
                }
            }
        }
    }
    
    private func onMarkerTapped(elementIDHashValue: Int) {
        if !selectedIndeciesHashValues.contains(elementIDHashValue) {
            selectedIndeciesHashValues.append(elementIDHashValue)
        } else {
            selectedIndeciesHashValues = Array(selectedIndeciesHashValues.drop(while: { index in
                index == elementIDHashValue
            }))
        }
    }
}
