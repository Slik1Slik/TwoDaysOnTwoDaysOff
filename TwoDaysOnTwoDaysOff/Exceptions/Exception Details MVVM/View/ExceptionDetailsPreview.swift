//
//  ExceptionDetailsPreview.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 04.04.2022.
//

import SwiftUI

struct ExceptionDetailsPreview: View {
    
    //private var viewModel: ExceptionDetailsViewModel
    
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(spacing: 16) {
            titleLabel
            dayKindLabel
            dateIntervalLabel
            detailsLabel
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var navigationBar: some View {
        Text("Детали")
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(
                HStack{
                    backButton
                    Spacer()
                }
            )
            .padding()
        
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(colorPalette.buttonPrimary)
                .font(.title2)
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
                Text("Вот так вот в жизни бывает")
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
