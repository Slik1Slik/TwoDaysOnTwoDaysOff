//
//  TabBarView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct TabBarView: View {
    typealias Constants = TabBarConstants
    
    @Binding var selection: Int
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(tabs.indices) { index in
                VStack(spacing: Constants.imageTitleSpacing) {
                    Image(systemName: tabs[index].image)
                        .frame(height: Constants.imageSize)
                    Text(tabs[index].title)
                        .font(.caption2)
                        .fixedSize()
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: Constants.itemWidth(count: 3), height: Constants.itemHeight)
                .padding(.bottom, Constants.paddingBottom)
                .padding(.top, Constants.paddingTop)
                .padding(.horizontal, Constants.paddingTrailing)
                .foregroundColor(selection == index ? Color(.label) : .secondary)
                .onTapGesture {
                    self.selection = index
                }
            }
        }
        .frame(width: Constants.width, height: Constants.height, alignment: .center)
        .overlay(Rectangle().stroke(Color(.label), lineWidth: 0.5))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selection: .constant(0))
    }
}

struct Tab {
    let image: String
    let title: String
}

struct TabItem: View {
    var image: String
    var title: String
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: image)
            Text(title)
                .font(.caption2)
        }
    }
}
let tabs: [Tab] = [
    Tab(image: "calendar", title: "Home"),
    Tab(image: "doc.plaintext", title: "Exceptions"),
    Tab(image: "gearshape", title: "Settings")
]
