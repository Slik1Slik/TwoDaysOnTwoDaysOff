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
        if exceptions.count > 0 {
            Divider()
            VStack {
                HStack {
                    Text("Исключения")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(exceptions, id: \.self) { exception in
                            Button(action: {
                                self.isPresented = true
                            },
                            label: {
                                HStack {
                                    Circle()
                                        .foregroundColor(exception.isWorking ? Color(UserSettings.workingDayCellColor!) : Color(UserSettings.restDayCellColor!))
                                        .frame(width: 10, height: 10, alignment: .center)
                                    Text(exception.name)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(.top, 10)
                                .padding(.leading, 10)
                            })
                            .sheet(isPresented: $isPresented) {
                                ExceptionDetailsView()
                            }
                        }
                    }
                }
            }
        }
    }
    private var header: some View {
        Text("Исключения")
            .font(.title3)
    }
    private var footer: some View {
        NavigationLink("Добавить исключение", destination: ExceptionDetailsView())
    }
    
    private var exceptions: [Exception] {
        let calendar = DateConstants.calendar
        guard let interval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        let predicate = NSPredicate(format: "from >= %@ AND to <= %@",
                                    argumentArray: [interval.start, interval.end])
        do {
            return try ExceptionsDataStorageManager.filtred(by: predicate)
        } catch {
            return []
        }
    }
    
    func getExceptions() {
        let calendar = DateConstants.calendar
        guard let interval = calendar.dateInterval(of: .month, for: month) else {
            return
        }
        let predicate = NSPredicate(format: "from >= %@ AND to <= %@",
                                    argumentArray: [interval.start, interval.end])
        do {
            let exceptions1 = try ExceptionsDataStorageManager.filtred(by: predicate)
            print(exceptions1.count)
            print(type(of: exceptions1))
        } catch {
            return
        }
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
