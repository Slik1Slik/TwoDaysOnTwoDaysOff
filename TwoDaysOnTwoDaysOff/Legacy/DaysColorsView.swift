//
//  DaysColorsView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct DaysColorsView: View
{
    private var colors: [String] = ["red", "systemRed", "blue", "systemBlue", "purple", "systemPurple", "green", "systemGreen", "orange", "systemOrange", "yellow", "systemYellow", "systemGray", "lightGray"]
    
    private var style: DaysColorsViewStyle = .normal
    @State var currentElement: Int = -1
    
    var completion: (String) -> () = {_ in }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .firstTextBaseline){
                ForEach(0..<colors.count, id: \.self) { item in
                    Color(colors.reversed(self.style == .reversed)[item])
                        .onTapGesture {
                            self.currentElement = item
                            self.completion(colors.reversed(self.style == .reversed)[item])
                        }
                        .overlay(Circle().stroke(Color.blue, lineWidth: self.currentElement == item ? 5 : 0))
                }.clipShape(Circle())
                .frame(minWidth: 10, idealWidth: 30, maxWidth: 60, minHeight: 10, idealHeight: 30, maxHeight: 60, alignment: .center)
            }
        }.frame(height: 30)
    }
    
    init(_ style: DaysColorsViewStyle, completion: @escaping (String)->()) {
        self.style = style
        self.completion = completion
    }
}

enum DaysColorsViewStyle {
    case normal
    case reversed
}

struct DaysColorsView_Previews: PreviewProvider {
    static var previews: some View {
        DaysColorsView(.normal, completion: {_ in})
    }
}
