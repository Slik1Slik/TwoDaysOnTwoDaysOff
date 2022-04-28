//
//  UserColorThemesObserver.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 25.04.2022.
//

import Combine
import UIKit

class UserColorThemesObserver: ObservableObject {
    
    var onAnyChange: () -> () = { }
    var onThemeAdded: () -> () = { }
    var onThemeUpdated: () -> () = { }
    var onThemeRemoved: () -> () = { }
    
    
    func startObserving() {
        NotificationCenter.default
            .addObserver(forName: UserColorThemeNotifications.themeHasBeenAdded, object: nil, queue: .main) { [weak self] _ in
                self?.onThemeAdded()
                self?.onAnyChange()
            }
        NotificationCenter.default
            .addObserver(forName: UserColorThemeNotifications.themeHasBeenUpdated, object: nil, queue: .main) { [weak self] _ in
                self?.onThemeUpdated()
                self?.onAnyChange()
            }
        NotificationCenter.default
            .addObserver(forName: UserColorThemeNotifications.themeHasBeenRemoved, object: nil, queue: .main) { [weak self] _ in
                self?.onThemeRemoved()
                self?.onAnyChange()
            }
    }
}


