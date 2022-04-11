//
//  ExceptionDetailsPreview.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 04.04.2022.
//

import SwiftUI

struct ExceptionDetailsPreview: View {
    
    //private var viewModel: ExceptionDetailsViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                titleLabel
                dayKindLabel
                dateIntervalLabel
                detailsLabel
                Spacer()
            }
            .padding()
            .navigationTitle("Детали")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var titleLabel: some View {
        HStack {
            Text("Замена")
                .font(.title2.bold())
            Spacer()
        }
    }
    
    private var dayKindLabel: some View {
        //"Внеплановый \(viewModel.isWorking ? "рабочий" : "выходной") день"
        HStack {
            Image(systemName: "")
            Text("Внеплановый выходной день")
                .font(.body)
            Spacer()
        }
    }
    
    private var dateIntervalLabel: some View {
        //"Внеплановый \(viewModel.isWorking ? "рабочий" : "выходной") день"
        HStack {
            Text("вторник, 27 окт. 2022 г.")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    private var detailsLabel: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Детали:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack {
                Text("Вот так вот в жизни бывает, пиздец просто, я ебал того маму, как же все остопиздело")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    
    init(date: Date) {
        //self.viewModel = ExceptionViewModelFactory(date: date).viewModel()
    }
}

struct ExceptionDetailsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionDetailsPreview(date: Date())
    }
}
