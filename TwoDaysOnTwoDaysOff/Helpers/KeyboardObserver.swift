//
//  KeyboardObserver.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.10.2021.
//

import UIKit
import Combine
import SwiftUI

class KeyboardObserver: ObservableObject {
    @Published private(set) var keyboardFrame: CGRect = CGRect()
    
    let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap {
            ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)
        }
    
    let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ -> CGRect in
            CGRect()
        }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.keyboardFrame, on: self)
            .store(in: &cancellableSet)
    }
}

