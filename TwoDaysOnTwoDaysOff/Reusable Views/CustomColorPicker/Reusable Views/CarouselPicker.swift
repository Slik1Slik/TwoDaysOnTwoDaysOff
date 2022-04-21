//
//  CarouselPicker.swift
//  CustomColorPicker
//
//  Created by Slik on 15.04.2022.
//

import Foundation
import SwiftUI

struct CarouselPicker<SelectionValue: Hashable, Content: View>: View {
    
    @Binding var selection: SelectionValue
    
    var values: [SelectionValue] = []
    
    var spacing: CGFloat = 5
    
    var content: (SelectionValue) -> Content
    
    var onSelect: (SelectionValue) -> () = { _ in }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(values, id: \.self) { value in
                    content(value)
                        .onTapGesture {
                            selection = value
                            onSelect(value)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
