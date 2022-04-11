//
//  ExceptionsList.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 03.04.2022.
//

import SwiftUI

struct ExceptionsList: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ExceptionListTableViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
