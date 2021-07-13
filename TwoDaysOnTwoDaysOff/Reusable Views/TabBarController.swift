//
//  TabBarController.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 05.07.2021.
//

import SwiftUI

struct TabBarController<Content: View>: View {
    @Binding var selection: Int
    var tabs: [Content]
    var body: some View {
        ZStack {
            ForEach(tabs.indices, id: \.self) { index in
                
            }
        }
    }
}

struct TabBarController_Previews: PreviewProvider {
    static var previews: some View {
        TabBarController(selection: .constant(0), tabs: [ExceptionsListView()])
    }
}
