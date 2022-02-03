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
    
    @Published private(set) var isKeyboardShown: Bool = false
    
    private let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap {
            ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)
        }
    
    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ -> CGRect in
            CGRect()
        }
    
    private let keyboardDidHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardDidHideNotification)
        .map { _ in
            return false
        }
    
    private let keyboardDidShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardDidShowNotification)
        .map { _ in
            return true
        }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.keyboardFrame, on: self)
            .store(in: &cancellableSet)
        
        Publishers.Merge(keyboardDidShow, keyboardDidHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.isKeyboardShown, on: self)
            .store(in: &cancellableSet)
        
    }
}

