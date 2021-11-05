//
//  MonthAccessoryView.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI

struct MonthAccessoryView: View {
    private var month: Date
    @State private var isPresented = false
    var body: some View {
        Text("")
    }
    private var header: some View {
        Text("Исключения")
            .font(.title3)
    }
    
    
    init(month: Date) {
        self.month = month
        //getExceptions()
    }
}

struct MonthAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        MonthAccessoryView(month: Date())
    }
}
