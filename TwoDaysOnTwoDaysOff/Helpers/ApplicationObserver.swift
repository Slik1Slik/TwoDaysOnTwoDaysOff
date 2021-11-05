//
//  ApplicationObserver.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 22.10.2021.
//

import UIKit
import Combine
import SwiftUI

class ApplicationObserver: ObservableObject {
    @Published var appIsActive: Bool = true
    
    let appWillResignActive = NotificationCenter.default
        .publisher(for: UIApplication.willResignActiveNotification)
        .compactMap { _ in
            false
        }
    
    let appWillDeactivate = NotificationCenter.default
        .publisher(for: UIScene.willDeactivateNotification)
        .compactMap { _ in
            false
        }
    
    let appDidBecomeActive = NotificationCenter.default
        .publisher(for: UIApplication.didBecomeActiveNotification)
        .map { _ in
            true
        }
    
    let appDidEnterBackground = NotificationCenter.default
        .publisher(for: UIApplication.didEnterBackgroundNotification)
        .map { _ in
            false
        }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        Publishers.Merge4(appWillResignActive, appDidEnterBackground, appDidBecomeActive, appWillDeactivate)
            .subscribe(on: RunLoop.main)
            .assign(to: \.appIsActive, on: self)
            .store(in: &cancellableSet)
    }
}
