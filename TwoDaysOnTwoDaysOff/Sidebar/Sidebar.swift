//
//  Sidebar.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.01.2022.
//

import SwiftUI

struct Sidebar: View {
    var body: some View {
        HStack {
            ScrollView {
                VStack {
                    NavigationLink("Exceptions", destination: ExceptionsListView())
                }
            }
            .padding(.top, LayoutConstants.safeFrame.minY)
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .frame(height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
    }
    
    private func row<Content: View>(imageName: String, title: String, destination view: Content) -> some View {
        NavigationLink {
            view
        } label: {
            HStack(spacing: LayoutConstants.perfectPadding(17)) {
                //Image(imageName, bundle: nil)
                Text(title)
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
